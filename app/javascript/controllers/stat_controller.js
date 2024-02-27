import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['genderFilter']

  selectedFilter(event){
    if (event.target.value == 'user') {
      this.genderFilterTarget.removeAttribute('disabled')
    } else {
      this.genderFilterTarget.setAttribute('disabled', true)
    }
  }
}
