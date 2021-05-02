import * as ActiveStorage from "activestorage";

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");


global.jQuery, global.$ = require("jquery");

ActiveStorage.start();
import 'bootstrap';
import "@oddcamp/cocoon-vanilla-js";
import 'gist-client'
require("./utilities/answer_edit_form")
require("./utilities/question_edit_form")
require("./utilities/rating")





