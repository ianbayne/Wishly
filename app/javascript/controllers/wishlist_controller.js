import { Controller } from "@hotwired/stimulus"
import { faker } from "@faker-js/faker";

export default class extends Controller {
  static targets = [ 'itemList', 'itemTemplate', 'inviteeList', 'inviteeTemplate' ];

  addItem(e) {
    e.preventDefault();

    const itemList = this.itemListTarget;
    const itemTemplate = this.itemTemplateTarget;
    const item = itemTemplate.content.cloneNode(true);

    const itemNumber = itemList.children.length;
    const itemNameInputId = `wishlist_wishlist_items_attributes_${itemNumber}_name`
    const itemNameInputName = `wishlist[wishlist_items_attributes][${itemNumber}][name]`
    const itemUrlInputId = `wishlist_wishlist_items_attributes_${itemNumber}_url`
    const itemUrlInputName = `wishlist[wishlist_items_attributes][${itemNumber}][url]`
    const randomWords = faker.random.words();
    const randomUrl = faker.internet.url()

    const nameInput = item.querySelectorAll('input')[0]
    nameInput.setAttribute('id', itemNameInputId);
    nameInput.setAttribute('name', itemNameInputName);
    nameInput.setAttribute('placeholder', `New ${randomWords.toLowerCase()}`);

    const urlInput = item.querySelectorAll('input')[1]
    urlInput.setAttribute('id', itemUrlInputId);
    urlInput.setAttribute('name', itemUrlInputName);
    urlInput.setAttribute('placeholder', randomUrl);

    itemList.appendChild(item);
  }

  addInvitee(e) {
    e.preventDefault();

    const inviteeList = this.inviteeListTarget;
    const inviteeTemplate = this.inviteeTemplateTarget;
    const invitee = inviteeTemplate.content.cloneNode(true);

    const inviteeNumber = inviteeList.children.length;
    const inviteeId = `wishlist_invitees_attributes_${inviteeNumber}_email`;
    const inviteeName = `wishlist[invitees_attributes][${inviteeNumber}][email]`;
    const randomEmail = faker.internet.email();

    const inviteeInput = invitee.querySelector('input');
    inviteeInput.setAttribute('id', inviteeId);
    inviteeInput.setAttribute('name', inviteeName);
    inviteeInput.setAttribute('placeholder', randomEmail);

    inviteeList.appendChild(invitee);
  }
};