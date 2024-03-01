import { Controller } from "@hotwired/stimulus"

const not_active = "inline-block p-4 rounded-t-lg hover:text-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 dark:hover:text-gray-300"
const active = "inline-block p-4 text-blue-600 bg-gray-100 rounded-t-lg active dark:bg-gray-800 dark:text-blue-500"
export default class extends Controller {
  connect() {
    const tabs = [
      { tab: document.getElementById("individual-tab"), form: document.querySelector(".individual-form"), table: document.querySelector(".gender-table") },
      { tab: document.getElementById("team-tab"), form: document.querySelector(".team-form"), table: document.querySelector(".team-table") },
      { tab: document.getElementById("state-tab"), form: document.querySelector(".state-form"), table: document.querySelector(".state-table") },
      { tab: document.getElementById("country-tab"), form: document.querySelector(".country-form"), table: document.querySelector(".country-table") }
    ];

    tabs.forEach(({ tab, form, table }) => {
      tab.addEventListener("click", () => {
        this.activateTab(tab);
        this.hideAllForms(tabs, form);
        this.hideAllTables(tabs, table);
        this.showForm(form);
        this.showForm(table);
      });
    });
  }

  activateTab(tab) {
    tab.parentElement.querySelectorAll(".active").forEach((el) => {
      el.removeAttribute('class')
      el.setAttribute('class', not_active)
    });
    tab.firstElementChild.removeAttribute('class')
    tab.firstElementChild.setAttribute('class', active);
  }

  hideAllForms(tabs, currentForm) {
    tabs.forEach(({ form }) => {
      if (form !== currentForm) {
        form.classList.add("hidden");
      }
    });
  }

  hideAllTables(tabs, currentTable) {
    tabs.forEach(({ table }) => {
      if (table !== currentTable) {
        table.classList.add("hidden");
      }
    });
  }

  showForm(form) {
    if (form){
      form.classList.remove("hidden");
    }
  }
}

