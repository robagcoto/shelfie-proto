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
    this.count = 1
  }

  addIngredients() {
    this.count += 1;
    console.log(this.count)
    console.log("J'ai appuyé sur le bouton");
    this.buttonTarget.remove();
    this.removeTarget.classList.remove("trash");
    this.rowTarget.insertAdjacentHTML("beforeend",`
    <div class="ingredient-row mb-2">
      <div class="col-4">
        <input type="text" name="ingredient_name${this.count}" id="ingredient_name" placeholder="Ingredients" class="form-control">
      </div>

      <div class="col-3">
        <input type="text" name="ingredient_quantity${this.count}" id="ingredient_quantity" placeholder="Quantity" class="form-control">
      </div>

      <div class="col-3">
        <select name="ingredient_unit${this.count}" id="ingredient_unit" class="form-select">
          <option value="g">g</option>
          <option value="l">l</option>
          <option value="pc(s)">pc(s)</option>
        </select>
      </div>

        <div class="col-1 ms-auto p-0 d-flex justify-content-center">
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
