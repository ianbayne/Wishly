import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["form"];

  submitForm(event) {
    let isValid = this.validateForm(this.formTarget);

    if (!isValid) {
      event.preventDefault();
    }
  }

  validateForm() {
    let isValid = true;

    let requiredFields = this.formTarget.querySelectorAll(
      "textarea:required, input:required"
    );

    requiredFields.forEach(field => {
      if (!field.disabled && !field.value.trim()) {
        field.focus();
        field.style.borderColor = "red";

        isValid = false;
      }
    });

    return isValid;
  }
}
