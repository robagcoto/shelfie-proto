import { Controller } from "@hotwired/stimulus"
import flatpickr from 'flatpickr';
// import "flatpickr/dist/flatpickr.min.css";

// Connects to data-controller="calendar"
export default class extends Controller {
  connect() {
    console.log("hello calendar");

    flatpickr(this.element, {
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d",
    })
  }
}
