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
  
#if no coupons return cart
if coupons == []
  return cart
end

#### Consolidate Coupons ###
newArr = []

coupons.each do |ele|
  if newArr.include?(ele)
    
    newArr[newArr.find_index(ele)][:num] = newArr[newArr.find_index(ele)][:num] + ele[:num]
    
    
    newArr[newArr.find_index(ele)][:cost] = newArr[newArr.find_index(ele)][:cost] + ele[:cost]
  else
    newArr.push(ele)
  end
end

coupons = newArr

#######


i = 0;


while i < coupons.count
  #find discounted item
  discounted_item = cart.select {|ele| ele == coupons[i][:item]}.to_h

  #if no discounted items return cart
  if discounted_item == {}
    return cart
  end


  #if num from coupons is less than count than apply coupons
  if  coupons[i][:num] <= discounted_item[coupons[i][:item]][:count]
    #begin creating new item
    new_item_key = "#{discounted_item.keys[0]} W/COUPON"
    new_item_values = discounted_item.values[0]

    #add a new k,v pair to cart
    new_name_copy = discounted_item.keys[0].to_s
    new_name_copy = "#{new_name_copy} W/COUPON"

    #create the new hash with its values...
    cart[new_name_copy] = {}
    cart[new_name_copy][:price] = coupons[i][:cost] / coupons[i][:num]
    cart[new_name_copy][:clearance] = discounted_item[coupons[i][:item]][:clearance]
    cart[new_name_copy][:count] = coupons[i][:num]


    #minus from the original AVOCADO
    cart[coupons[i][:item]][:count] = cart[coupons[i][:item]][:count] - coupons[i][:num]
  end
i += 1
end

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
 puts hold
 sum = 0
  hold.each do |k, v|
    price = v[:price] * v[:count]
     sum = price + sum
  end
  
  if sum > 100
    sum = sum - (sum * 0.10)
  end
  sum
end



