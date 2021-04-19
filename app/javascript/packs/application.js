require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
import "bootstrap"
document.addEventListener("turbolinks:load", ()=>{
   $('[data-toggle="tooltip"]').tooltip()
   $('[data-toggle="popover"]').popover()
})

global.jQuery, global.$ = require("jquery");

require("./utilities/answer_edit_form")
require("./utilities/question_edit_form")



