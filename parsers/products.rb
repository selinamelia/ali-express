#taking the html string of the page that is inside the “content” 
nokogiri = Nokogiri.HTML(content)

# initialize an empty hash
product = {}

#save the url
product['url'] = page['vars']['url']

#save the category
product['category'] = page['vars']['category']

#extract title
product['title'] = nokogiri.at_css('h1.product-title-text').text

#extract product image
product['image_url'] = nokogiri.at_css('img.magnifier-image')['src']

# price_element = nokogiri.css('.product-price')
# if price_element
#     #extract discounted price
#     current_price = price_element.at_css('product-price-value span.product-price-value').text
#     if current_price
#         product['current_price'] = current_price
#     end
#     #extract discount 
#     product['discount'] = nokogiri.at_css('span.product-price-mark')&.text
#     if  product['discount']
#         #extract original price
#         product['original_price'] = price_element.at_css('.product-price-original .product-price-del span').text
#     end
# end

#extract SKUs
skus_element = nokogiri.css('.product-quantity-tip')
if skus_element
    skus = skus_element.at_css('span span').text
    product['skus'] = skus
end

#extract sizes
sizes_element = nokogiri.css('ul.sku-property-list')
if sizes_element
	sizes = sizes_element.css('div.sku-property-text').collect {|i| i.text.strip}
	product['sizes'] = sizes
end

#extract rating and reviews
rating = product['rating'] = nokogiri.at_css('div.positive-fdbk')[0].text
if rating
    product['rating'] = rating
end

#extract orders count
product['orders_count'] = nokogiri.at_css('span.product-reviewer-sold').text.strip.split(' ').first.to_i


# #extract shipping info
# shipping_element = nokogiri.at_css('dl#j-product-shipping')
# if shipping_element
#     product['shipping_info'] = shipping_element.text.strip.gsub(/\s\s+/, ' ')
# end

# extract return policy
return_element = nokogiri.css('div.buyer-pretection-content')
if return_element
    return_policy_title = return_element.at_css('div.buyer-pretection-title').text.strip
    return_policy_context = return_element.at_css('div.buyer-pretection-context').text.strip
    if return_policy_title && return_policy_context
        product['return_policy'] = return_policy_title + ". " + return_policy_context
    end
end

# #extract guarantee
# guarantee_element = nokogiri.at_css('#serve-guarantees-detail')
# if guarantee_element
#     product['guarantee'] = guarantee_element.text.strip.gsub(/\s\s+/, ' ')
# end

# specify the collection where this record will be stored
product['_collection'] = "products"

# save the product to the job’s outputs
outputs << product
