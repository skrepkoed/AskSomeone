$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
	  e.preventDefault();
		var answerId = $(this).data('answerId');
    if ($('#answer-'+answerId+' .answer_edit_hidden').is(":hidden")){
      
      $('#answer-'+answerId+' .answer_edit_hidden').show()
      $('.answers #answer-'+answerId+' input[type=submit]').val('Edit')

    }else{
      $('#answer-'+answerId+' .answer_edit_hidden').hide()
    }})
});