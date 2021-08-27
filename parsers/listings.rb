nokogiri = Nokogiri.HTML(content)

products = nokogiri.css('.JIIxO ._1OUGS')
product_ids = []

products.each do |product|
    a_element = product.at_css('a.awV9E')
    # name = product.at_css('a.awV9E > span')&.text
    product_ids << a_element['href'].scan(/[0-9]+/)[0]
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
                    page_num: page['vars']['page_num']
                    # name: name
                }
            }
        end
    end
end

url = "https://www.aliexpress.com/glosearch/api/product?trafficChannel=main&catName=women-clothing&CatId=100003109&ltype=wholesale&SortType=default&page=2&origin=y&pv_feature=#{product_ids.join(',')}"
pages << {
	url: url,
	page_type: 'listings_json',
	force_fetch: true,
	method: 'GET',
	headers: {"User-Agent" => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"},
	vars: {
		 page_num: 2
	}
}

# load paginated links
# current_page = nokogiri.at_css('button.next-current')&.text.to_i
# if current_page == 1
#     max_page_tag = nokogiri.at_css('span.total-page')&.text
#     max_page = max_page_tag.split(' ')[1].to_i

#     for i in 2..max_page
#         next_page_url = "https://www.aliexpress.com/category/100003109/women-clothing.html?page=" + i
#         pages << {
#             page_type: 'listings',
#             url: next_page_url,
#             method: "GET",
#             force_fetch: true,
#             fetch_type: "browser",
#             vars: {
#                 page_num: 1
#             }
#         }

#         if i >= max_page
#             break 
#         end
#     end
# end