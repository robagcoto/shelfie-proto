import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-ingredients"
export default class extends Controller {
  static targets = ["button","row","delete","remove"]

  connect() {
    console.log("connect");
    console.log(this.buttonTarget);
    console.log(this.rowTarget)
    console.log(this.deleteTarget)
    console.log(this.removeTarget)
  }

  addIngredients() {
    console.log("J'ai appuyé sur le bouton");
    this.buttonTarget.remove();
    this.removeTarget.classList.remove("trash");
    this.rowTarget.insertAdjacentHTML("beforeend",`<div class="ingredient-row">
      <div class="col-4 mb-2">
        <input type="text" name="ingredient_name" id="ingredient_name" placeholder="Ingredients" class="form-control">
        </div>

      <div class="col-4">
        <input type="text" name="ingredient_quantity" id="ingredient_quantity" placeholder="Quantity" class="form-control">
          </div>

      <div class="col-2">
        <select name="ingredient_unit" id="ingredient_unit" class="form-select"><option value="l">l</option>
<option value="g">g</option>
<option value="pc(s)">pc(s)</option></select>
        </div>

        <div class="col-2 p-0 d-flex justify-content-center">
          <button data-ingredients-target="button" data-action="click->ingredients#addIngredients" type="button" class="btn btn-primary">+</button>
          </div>
      </div>`
  )
 }

 removeRow(){
  console.log("button click")
  this.removeTarget.remove();
 }
}
