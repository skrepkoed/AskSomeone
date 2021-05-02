$(document).on('turbolinks:load', function(){
const rating_links = document.querySelectorAll(".rating-link");
const pro_link = document.querySelectorAll('.rating-link-pro')
const con_link = document.querySelectorAll('.rating-link-con')
$('.question .rating-message').empty()
  rating_links.forEach((element) => {
    element.addEventListener("ajax:success", (e) => {
      let resource = e.path[1]
      let resource_id = '#'+ resource.id
      $( resource_id+' .rating').html( 'Rating:' + ' ' + e.detail[0].rating)
      $(resource_id+' .rating-message').empty()
    });
    element.addEventListener("ajax:error",(e) => {
      let resource = e.path[1]
      let resource_id = '#'+ resource.id 
      $(resource_id+' .rating-message').html(' ' + e.detail[0])
    })
  });
  pro_link.forEach((element) => {
  element.addEventListener("ajax:success", (e) => {
    let resource = e.path[1]
    let resource_id = '#'+ resource.id
    if (element.innerText =="Voted" || element.innerText =="Revote"){
      $(resource_id+' .rating-link-pro').html("Vote pro")
      $(resource_id+' .rating-link-con').html("Vote con")
    }else{
      $(resource_id+' .rating-link-pro').html("Voted")
      $(resource_id+' .rating-link-con').html("Revote")
    }
  })
})

  con_link.forEach((element) => {
  element.addEventListener("ajax:success", (e) => {
    let resource = e.path[1]
    let resource_id = '#'+ resource.id
    if (element.innerText =="Voted" || element.innerText =="Revote"){
      $(resource_id+' .rating-link-pro').html("Vote pro")
      $(resource_id+' .rating-link-con').html("Vote con")
    }else{
      $(resource_id+' .rating-link-con').html("Voted")
      $(resource_id+' .rating-link-pro').html("Revote")
    }
  })
})
})