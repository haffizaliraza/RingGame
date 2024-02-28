import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const individualTab = document.getElementById("individual-tab");
    const teamTab = document.getElementById("team-tab");
    const individualForm = document.querySelector(".individual-form");
    const teamForm = document.querySelector(".team-form");

    individualTab.addEventListener("click", function() {
        individualTab.classList.add("border-blue-500");
        individualTab.classList.remove("border-transparent");
        teamTab.classList.remove("border-blue-500");
        teamTab.classList.add("border-transparent");
        individualForm.classList.remove("hidden");
        teamForm.classList.add("hidden");
    });

    teamTab.addEventListener("click", function() {
        teamTab.classList.add("border-blue-500");
        teamTab.classList.remove("border-transparent");
        individualTab.classList.remove("border-blue-500");
        individualTab.classList.add("border-transparent");
        teamForm.classList.remove("hidden");
        individualForm.classList.add("hidden");
    });
  }
}
