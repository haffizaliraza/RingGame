import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const not_active = "inline-block p-4 rounded-t-lg hover:text-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 dark:hover:text-gray-300"
    const active = "inline-block p-4 text-blue-600 bg-gray-100 rounded-t-lg active dark:bg-gray-800 dark:text-blue-500"
    const individualTab = document.getElementById("individual-tab");
    const teamTab = document.getElementById("team-tab");
    const individualForm = document.querySelector(".individual-form");
    const teamForm = document.querySelector(".team-form");

    individualTab.addEventListener("click", function() {
      individualTab.children[0].removeAttribute('class');
      individualTab.children[0].setAttribute('class', active);
      teamTab.children[0].removeAttribute('class');
      teamTab.children[0].setAttribute('class', not_active);
      individualForm.classList.remove("hidden");
      teamForm.classList.add("hidden");
    });

    teamTab.addEventListener("click", function() {
        individualTab.children[0].removeAttribute('class');
        individualTab.children[0].setAttribute('class', not_active);
        teamTab.children[0].removeAttribute('class');
        teamTab.children[0].setAttribute('class', active);
        teamForm.classList.remove("hidden");
        individualForm.classList.add("hidden");
    });
  }
}
