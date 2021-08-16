nokogiri = Nokogiri.HTML(content)

products = nokogiri.css('div.JIIxO div._1OUGS')
products.each do |product|
    a_element = product.at_css('a.awV9E')
    if a_element
        url = URI.join('https://www.aliexpress.com', a_element['href']).to_s.split('?').first
        if url =~ /\Ahttps?:\/\//i
            pages << {
                url: url,
                page_type: 'products',
                fetch_type: 'browser',
                force_fetch: true,
                vars: {
                    category: page['vars']['category'],
                    url: url
                }
            }
        end
    end
end

#load paginated links
pagination_links = nokogiri.css('#pagination-bottom a')
pagination_links.each do |link|
    l_val = link.text.strip
    if l_val !~ /next|previous/i && l_val.to_i < 11 #limit pagination to 10 pages
        url = URI.join('https:', link['href']).to_s.split('?').first
        pages << {
            url: url,
            page_type: 'listings'
        }
    end
end
