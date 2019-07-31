require 'nokogiri'
require 'json'

# Writen by Steven Bedrick and modified by Shiran Dudy
# shirdu2@gmail.com

def process_article(art)
  this_pub = {}
  
  # if not table of figure or equation remove reference
  #  a.zip(b) zipped lists
  both = art.xpath('//xref/@ref-type').zip(art.xpath('//xref'))
  both.each do |tag,elem| 
    if tag.text != 'table' || tag.text != 'fig' || tag.text != 'fn' || tag.text != 'sec' || tag.text != 'disp-formula'
      elem.remove
      end
  end

  jrn_meta = art / "article/front/journal-meta"
  this_pub[:jrn_id] = (jrn_meta / "journal-id[journal-id-type='nlm-ta']").text
  art_meta = art / "/article/front/article-meta"

  this_pub[:pmid] = (art_meta / "article-id[pub-id-type='pmid']").text

  this_pub[:pmcid] = (art_meta / "article-id[pub-id-type='pmc']").text
#  this_pub[:doi] = (art_meta / "article-id[pub-id-type='doi']").text

  # title
  title_node = (art_meta / "title-group/article-title")
  
  # SDB Note 8/2016
  # Turns out that some of the article titles include footnotes or super/subscripts which occurred at the end of a title, 
  # which are represented by embedded tags (e.g. <fn> or something like that),and calling .text on the title node was 
  # including those (and messing stuff up in the process).
  # We thought that we only needed to worry about tags at the end of titles, and so for trec CDS 2016 we just used the first child node and called it good.
  # This turned out to be insufficient- in the latest PMC release, there are titles with italic text (cf. PMC1079931),
  # and the approach below fails in these cases. 
  # TODO: a more robust title-parsing algorithm
  
  if title_node.children.size > 1
    this_pub[:title] = title_node.children.first.text.strip
  else
    this_pub[:title] = title_node.text.strip
  end

  # pub_year
  # if ppub, use that; else use collection
  ppub = (art_meta / "pub-date[pub-type='ppub']/year").text
  epub = (art_meta / "pub-date[pub-type='epub']/year").text
  year = nil
  if ppub.strip.length > 0
    year = ppub.strip
  else
    year = epub.strip
  end
  this_pub[:year] = year 

  # abstract (if present)
  abst_node = art_meta / "abstract"
  
  this_pub[:abstract] = {}
  if abst_node.length == 0
    this_pub[:abstract][:full] = ""
  elsif (abst_node / "sec").size > 0 # structured abstract (inc. section headings)
    abstract_full = ""  
    # go through each section, and get the parts out in some kind of order
    (abst_node / "sec").each do |s|
      # rm furmulas
      s.search('//p/disp-formula').each do |node|
        node.remove
        end 
      s.search('//p/inline-formula').each do |node|
        node.remove
        end
      s.search('//title/disp-formula').each do |node|
        node.remove
        end
      s.search('//title/inline-formula').each do |node|
        node.remove
        end
      ti = (s / "title").text.strip
      body = (s / "p").text.strip
      # clean leftovers of xref
      body = body.gsub(/\(-*\)/, "")
      body = body.gsub(/\[,*\]/, "")
      body = body.gsub(/\[-*\]/, "")
      body = body.gsub(/\(,*\)/, "")
      ti = ti.gsub(/\[-*\]/, "")
      ti = ti.gsub(/\(,*\)/, "")
      ti = ti.gsub(/\(-*\)/, "")
      ti = ti.gsub(/\[,*\]/, "")
      abstract_full << ti << "\n"
      abstract_full << body << "\n"
    end
    this_pub[:abstract][:full] = abstract_full.strip
  end
  if (abst_node / "p").size > 0 # unstructured abstract
    abstract_full = this_pub[:abstract][:full].to_s
    (abst_node / "p").each do |s|
      s.search('//disp-formula').each do |node|
        node.remove
        end
      s.search('//inline-formula').each do |node|
        node.remove
        end
      abs = s.text.strip
      abs = abs.gsub(/\[-*\]/, "")
      abs = abs.gsub(/\(,*\)/, "")
      abs = abs.gsub(/\(-*\)/, "")
      abs = abs.gsub(/\[,*\]/, "")
      abstract_full << abs << "\n"
    end
    this_pub[:abstract][:full] = abstract_full
  else
    STDERR.puts "Other format found: " + (art_meta / "article-id[pub-id-type='pmc']").text
    this_pub[:abstract][:full] = ""
  end
  
  # now do body- similar deal
  this_pub[:body] = {}
  body_node = art / "/article/body"
  
  if (body_node / "sec").size > 0
    body_full = ""
    (body_node / "sec").each do |s|
      # rm xref
      # rm furmulas
      s.search('//p/disp-formula').each do |node|
        node.remove
        end
      s.search('//p/inline-formula').each do |node|
        node.remove
        end
      s.search('//title/disp-formula').each do |node|
        node.remove
        end
      s.search('//title/inline-formula').each do |node|
        node.remove
        end
      s.search('//fig/caption/p/disp-formula').each do |node|
        node.remove
        end
      s.search('//fig/caption/p/inline-formula').each do |node|
        node.remove
        end
      s.search('//table-wrap/table-wrap-foot/p/disp-formula').each do |node|
        node.remove
        end
      s.search('//table-wrap/table-wrap-foot/p/inline-formula').each do |node|
        node.remove
        end
      s.search('//table-wrap/table-wrap-foot/fn/disp-formula').each do |node|
        node.remove
        end
      s.search('//table-wrap/table-wrap-foot/fn/inline-formula').each do |node|
        node.remove
        end

      ti = (s / "title").text.strip
      body = (s / "p").text.strip
      fig_cap = (s / "fig/caption/p").text.strip
      tbl_cap = (s / "table-wrap/table-wrap-foot/p").text.strip
      tbl_fn = (s / "table-wrap/table-wrap-foot/fn").text.strip

      # clean leftovers of xref
      ti = ti.gsub(/\[-*\]/, "")
      ti = ti.gsub(/\(,*\)/, "")
      ti = ti.gsub(/\(-*\)/, "")
      ti = ti.gsub(/\[,*\]/, "")
      body = body.gsub(/\[-*\]/, "")
      body = body.gsub(/\(,*\)/, "")
      body = body.gsub(/\(-*\)/, "")
      body = body.gsub(/\[,*\]/, "")
      fig_cap = fig_cap.gsub(/\[-*\]/, "")
      fig_cap = fig_cap.gsub(/\(,*\)/, "")
      fig_cap = fig_cap.gsub(/\(-*\)/, "")
      fig_cap = fig_cap.gsub(/\[,*\]/, "")
      tbl_cap = tbl_cap.gsub(/\[-*\]/, "")
      tbl_cap = tbl_cap.gsub(/\(,*\)/, "")
      tbl_cap = tbl_cap.gsub(/\(-*\)/, "")
      tbl_cap = tbl_cap.gsub(/\[,*\]/, "")
      tbl_fn = tbl_fn.gsub(/\[-*\]/, "")
      tbl_fn = tbl_fn.gsub(/\(,*\)/, "")
      tbl_fn = tbl_fn.gsub(/\(-*\)/, "")
      tbl_fn = tbl_fn.gsub(/\[,*\]/, "")
      body_full << ti << "\n"
      body_full << body << "\n"
      body_full << fig_cap << "\n"
      body_full << tbl_cap << "\n"
      body_full << tbl_fn << "\n"
    end
    this_pub[:body][:full] = body_full.strip
  end

  if (body_node / "p").size > 0 # found the sec and p can coexist 2660466.nxml
    body_full = this_pub[:body][:full].to_s
    (body_node / "p").each do |s|
      s.search('//disp-formula').each do |node|
        node.remove
        end
      s.search('//inline-formula').each do |node|
        node.remove
        end
      body = s.text.strip
      body = body.gsub(/\[-*\]/, "")
      body = body.gsub(/\(,*\)/, "")
      body = body.gsub(/\(-*\)/, "")
      body = body.gsub(/\[,*\]/, "")
      body_full << body << "\n"
      end
    this_pub[:body][:full] = body_full   
  else
    STDERR.puts "Serious weirdness in body: "+ (art_meta / "article-id[pub-id-type='pmc']").text
  end
  
  
  return this_pub
end

inpath = ARGV[0].to_s
outpath = ARGV[1].to_s
fnames = Dir[inpath + "*.nxml"]
outfile = File.open(outpath, "w")

fnames.each_with_index do |fname, idx|

  print ". " if idx % 100 == 0
  puts idx if idx % 1000 == 0
  
  f = File.open(fname)
  s = f.readlines.join
  n = Nokogiri::XML(s)

  j = process_article(n).to_json
  outfile.puts j
end
outfile.close

puts "Done!"
