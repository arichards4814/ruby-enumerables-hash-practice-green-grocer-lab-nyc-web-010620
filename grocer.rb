def consolidate_cart(cart)

 arr = []
  newHash = {}

 cart.each do |k,v|
  arr.push(k.keys[0]) 
 end

 cart.each_with_index do |ele, index|
    ele[ele.keys[0]][:count] = arr.count(arr[index])
 end

 cart.map do |ele|
    newHash[ele.keys[0]] = ele[ele.keys[0]]
 end

newHash

end



def apply_coupons(cart, coupons)

additionToCart = {}

  coupons.each do |coupon|
    puts coupon
    cart.each do |item|
    
    itemName = item[0]
    if item[0] == coupon[:item] && item[1][:count] >= coupon[:num]
      if additionToCart["#{itemName} W/COUPON"]
        puts "this happened for the increment"
        additionToCart["#{itemName} W/COUPON"][:count] += coupon[:num]
      else
        additionToCart["#{itemName} W/COUPON"] = {:price=>coupon[:cost]/coupon[:num],:clearance=>cart[itemName][:clearance],:count=>coupon[:num]}
      end
      cart[itemName][:count] -= coupon[:num]
    end
  end
end
  
    additionToCart.each do |k, v|
      cart[k] = v
    end


  # puts cart
  cart
end


def apply_clearance(cart)
   # code here
 new_hash_test = {}
  
  cart.reduce(nil) do |memo, (key, value)|
    
    # On the first pass, we don't have a name, so just grab the first one.
    memo = value[0] if !memo
      if cart[key][:clearance] 
      new_hash_test[key] = value 
      new_hash_test[key][:price] = new_hash_test[key][:price] * 0.8
      new_hash_test[key][:price] = new_hash_test[key][:price].round(2)
      else
      new_hash_test[key] = value
      end
    memo = cart[key]
    #puts memo
   
  end

  new_hash_test
end


def checkout(cart = {}, coupons = [])
 hold = consolidate_cart(cart)
 hold = apply_coupons(hold,coupons)
 hold = apply_clearance(hold)
#  puts hold
 sum = 0
  hold.each do |k, v|
    price = v[:price] * v[:count]
     sum = price + sum
  end
  
  if sum > 100
    sum = sum - (sum * 0.10)
  end
  # puts "total cart:"
  # puts sum
  sum
end


