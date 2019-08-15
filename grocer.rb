require "pry"

def consolidate_cart(cart)
  cart_hash = {} #=> create new hash
  cart.each do |item|
    item_name = item.keys.first 
    
      #=> .first is same as "element at item zero"
      #=> item refers to the hash within the Array
      #=> item.keys.first will grab the key (here a food name) at index zero
      
    if cart_hash[item_name]
      cart_hash[item_name][:count] += 1 
      
      #=> if cart_hash already has food name, increment count key (:count)
    else 
      cart_hash[item_name] = item.values.first  
      cart_hash[item_name][:count] = 1
      
      #=> if cart_hash doesn't have the food name, set :count key equal to 1
    end 
  end
  cart_hash   #=> return new hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|          #=> for each coupon 
    coupon_name = coupon[:item]     #=> set "coupon_name" variable equal to the value assoc. with the "item" key in the coupon hash
    
      if cart.has_key?(coupon_name) && !cart.has_key?("#{coupon_name} W/COUPON") && cart[coupon_name][:count] >= coupon[:num]
        
        #=> if there is a coupon for an item in the car and the hash key of "#{coupon_name} W/COUPON" doesn't exist and there are still items in the cart to which the coupons can be applied
        
        cart["#{coupon_name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num],:clearance => cart[coupon_name][:clearance],:count => coupon[:num]}
        
        #=> create has with "#{coupon_name} W/COUPON" as key and a set of hashes as the value; set keys within these inner hashes to match those in the cart
        
        cart[coupon_name][:count] -= coupon[:num]
        
        #=> subtract count associated with coupon from the number of items in cart 
        
      elsif cart.has_key?("#{coupon_name} W/COUPON") && cart[coupon_name][:count] >= coupon[:num]
        cart["#{coupon_name} W/COUPON"][:count] += coupon[:num]
        #=> if the "#{coupon_name} W/COUPON" key already exists and there are still items in the cart to which coupons can be applied, 
        
        cart[coupon_name][:count] -= coupon[:num]
        
        #=> subtract count associated with coupon from the number of items in cart 
        
    end
  end
  cart    #=> return cart (now updated with coupons)
end

def apply_clearance(cart)
  cart.each do |item, price_hash|     
    #=> for each item in cart, 
    
    if price_hash[:clearance] == true
      #=> if there is a clearance on the item
      
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
      
      #=> revise price to equal 80% of original price (20% discount) and round to 2 decimal places
    end
  end
  cart    #=> return cart (now updated with clearance)
end


def checkout(cart, coupons)
  total = 0     #=> start with value of zero
  hash_cart = consolidate_cart(cart)  
  
  #=> create variable for cart once consolidate_cart method has been applied 
  
  coupon_cart = apply_coupons(hash_cart, coupons)
  
  #=> create variable for cart once apply_coupons method has been applied
  
  clearance_cart = apply_clearance(coupon_cart)
  
  clearance_cart.each do |item, values|
    total += values[:price] * values[:count]
  end
  
  if total > 100
    total = total * 0.9
  end
  total
end
