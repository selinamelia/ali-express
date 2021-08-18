nokogiri = Nokogiri.HTML(content)

products = nokogiri.css('div.JIIxO > div._1OUGS')
products.each do |product|
    a_element = product.at_css('a.awV9E')
    name = product.at_css('a.awV9E > span')&.text
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
                    url: url,
                    name: name
                }
            }
        end
    end
end


# load paginated links
current_page = nokogiri.at_css('button.next-current')&.text.to_i
if current_page == 1
    max_page_tag = nokogiri.at_css('span.total-page')&.text
    max_page = max_page_tag.split(' ')[1].to_i

    for i in 2..max_page
        next_page_url = "https://www.aliexpress.com/category/100003109/women-clothing.html?page=" + i
        pages << {
            page_type: 'listings',
            url: next_page_url,
            method: "GET",
            force_fetch: true,
            fetch_type: "browser",
            vars: {
                page_num: 1
            }
        }

        if i >= max_listing_page_to_scrape
            break 
        end
    end
end