$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    var questionId = $(this).data('questionId');
  if ($('#question-'+questionId+' .question_edit_hidden').is(":hidden")){    
    $('#question-'+questionId+' .question_edit_hidden').show()
    $('#question-'+questionId+' .question_edit_hidden input[type=submit]').val('Edit')
  }else{
    $('#question-'+questionId+' .question_edit_hidden').hide()}
  })
});