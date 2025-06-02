import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  static targets = ["userMessage"]
  connect() {
    console.log(document.querySelector(".user-messages"))
    console.log("connect")
  }

  injectMessage() {
  console.log("click")
  const content = this.userMessageTarget.value
  console.log(content)
  var injectArea = this.element.querySelector(".user-messages")
  injectArea.textContent = content
  }
}
