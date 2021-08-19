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

#extract discount 
product['discount'] = nokogiri.at_css('span.product-price-mark').text

price_element = nokogiri.css('.product-price')
if price_element
    #extract discounted price
    product['current_price'] = price_element.at_css('span.product-price-current span').text

    #extract original price
    product['original_price'] = price_element.at_css('span.product-price-del span').text
end

#extract SKUs
skus_element = nokogiri.css('.product-quantity-tip')
if skus_element
    skus = skus_element.at_css('span span').text
    product['skus'] = skus
end

#extract sizes
product['size'] = nokogiri.at_css('span.sku-title-value').text

#extract rating and reviews
product['rating'] = nokogiri.at_css('div.positive-fdbk')[1].text

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
    product['return_policy'] = return_policy_title + ". " + return_policy_context
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