import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.classList.add("visible");
    setTimeout(() => {
      this.element.classList.remove("visible");
    }, 3000); // 3秒後にフラッシュメッセージを非表示
  }
}
