$(document).on('turbolinks:load', function(){
const rating_links = document.querySelectorAll(".question .rating-link");
  rating_links.forEach((element) => {
    element.addEventListener("ajax:success", (e) => {
      $('.question .rating').html( 'Rating:' + ' ' + e.detail[0].rating)
    });
  });
})