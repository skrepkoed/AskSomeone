$(document).on('turbolinks:load', function(){
const rating_links = document.querySelectorAll(".question .rating-link");
const pro_link = document.querySelector('.question .rating-link-pro')
const con_link = document.querySelector('.question .rating-link-con')
$('.question .rating-message').empty()
  rating_links.forEach((element) => {
    element.addEventListener("ajax:success", (e) => {
      $('.question .rating').html( 'Rating:' + ' ' + e.detail[0].rating)
      $('.question .rating-message').empty()
    });
    element.addEventListener("ajax:error",(e) => {
      $('.question .rating-message').html(' ' + e.detail[0])
    })
  });
  pro_link.addEventListener("ajax:success", (e) => {
    if (pro_link.innerText =="Voted" || pro_link.innerText =="Revote"){
      $('.question .rating-link-pro').html("Vote pro")
      $('.question .rating-link-con').html("Vote con")
    }else{
      $('.question .rating-link-pro').html("Voted")
      $('.question .rating-link-con').html("Revote")
    }
  })

  con_link.addEventListener("ajax:success", (e) => {
    if (con_link.innerText =="Voted" || con_link.innerText =="Revote"){
      $('.question .rating-link-pro').html("Vote pro")
      $('.question .rating-link-con').html("Vote con")
    }else{
      $('.question .rating-link-con').html("Voted")
      $('.question .rating-link-pro').html("Revote")
    }
  })
})