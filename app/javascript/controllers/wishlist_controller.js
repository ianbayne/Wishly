import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'itemList', 'itemTemplate', 'inviteeList', 'inviteeTemplate' ];

  addItem(e) {
    e.preventDefault();

    const itemList = this.itemListTarget;
    const itemTemplate = this.itemTemplateTarget;
    const item = itemTemplate.content.cloneNode(true);

    const itemNumber = itemList.children.length;
    const itemId = `wishlist_wishlist_items_attributes_${itemNumber}_name`
    const itemName = `wishlist[wishlist_items_attributes][${itemNumber}][name]`

    const itemInput = item.querySelector('input')
    itemInput.setAttribute('id', itemId);
    itemInput.setAttribute('name', itemName);

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

    const inviteeInput = invitee.querySelector('input');
    inviteeInput.setAttribute('id', inviteeId);
    inviteeInput.setAttribute('name', inviteeName);

    inviteeList.appendChild(invitee);
  }
};