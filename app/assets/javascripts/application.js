//= require jquery
//= require jquery_ujs
//= require_tree .

//= require Hello

$(document).ready(function() {
  $('a.add-to-cart').click(function(event) {
    var product_id = $(event.target).data('product-id');
    $.post('/cart/items', { "item": { product_id: product_id, quantity: 1 } }, function(data) {
      var cart_size = data.items.reduce(function(sum, item) {
        return sum + item["quantity"];
      }, 0);

      if(cart_size > 0) {
        $('.nav .cart').text("My Cart (" + cart_size + ")");
      } else {
        $('.nav .cart').text("My Cart");
      }
    });
  });
});
