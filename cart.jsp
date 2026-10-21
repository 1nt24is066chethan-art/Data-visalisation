<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Shopping Cart</title>
<style>
  :root{
    --ink:#141414;
    --paper:#f5f4f0;
    --line:#141414;
    --accent:#ff4d1c;
    --accent-ink:#141414;
  }

  *{ box-sizing:border-box; margin:0; padding:0; }

  body{
    font-family: 'Helvetica Neue', Arial, sans-serif;
    background:var(--paper);
    color:var(--ink);
  }

  /* ===== NAVBAR ===== */
  .navbar{
    display:grid;
    grid-template-columns: 1fr auto 1fr;
    align-items:center;
    padding: 18px 40px;
    background:var(--paper);
    border-bottom: 3px solid var(--ink);
  }

  .logo{
    font-size: 22px;
    font-weight: 800;
    letter-spacing: 2px;
    text-transform: uppercase;
    justify-self:start;
  }
  .logo span{ color:var(--accent); }

  .nav-center{
    display:flex;
    gap: 28px;
    justify-self:center;
    align-items:center;
  }

  .search-bar{
    display:flex;
    align-items:center;
    border: 2px solid var(--ink);
    border-radius: 999px;
    padding: 8px 16px;
    gap: 8px;
  }

  .search-bar input{
    border:none;
    background:transparent;
    outline:none;
    font-size: 14px;
    font-family: 'Helvetica Neue', Arial, sans-serif;
    color:var(--ink);
    width: 200px;
  }

  .search-bar input::placeholder{
    color:#999;
  }

  .search-btn{
    background:none;
    border:none;
    cursor:pointer;
    font-size: 16px;
    color:var(--ink);
    font-weight:700;
  }

  .nav-center a{
    position:relative;
    text-decoration:none;
    color:var(--ink);
    font-weight:700;
    font-size: 15px;
    letter-spacing: 1px;
    text-transform: uppercase;
    padding: 6px 2px;
  }

  .nav-center a::after{
    content:"";
    position:absolute;
    left:0; bottom:-2px;
    width:0%;
    height:3px;
    background:var(--accent);
    transition: width .25s ease;
  }

  .nav-center a:hover::after{ width:100%; }

  .nav-right{
    display:flex;
    gap: 14px;
    justify-self:end;
    align-items:center;
  }

  .btn{
    text-decoration:none;
    font-weight:700;
    font-size: 13px;
    letter-spacing: 1px;
    text-transform: uppercase;
    padding: 10px 20px;
    border-radius: 999px;
    border: 2px solid var(--ink);
    transition: all .2s ease;
  }

  .btn-login{
    color:var(--ink);
    background:transparent;
  }
  .btn-login:hover{
    background:var(--ink);
    color:var(--paper);
  }

  /* mobile */
  @media (max-width: 700px){
    .navbar{
      grid-template-columns: 1fr;
      row-gap: 14px;
      padding: 16px 20px;
    }
    .logo, .nav-center, .nav-right{ justify-self:center; }
    .nav-center{ gap: 20px; flex-direction: column; }
    .search-bar input{ width: 150px; }
  }

  /* ===== CART CONTAINER ===== */
  .cart-container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 40px;
    padding: 40px;
    max-width: 1200px;
    margin: 0 auto;
  }

  /* Left side - Image */
  .cart-image {
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    border: 2px solid var(--ink);
    padding: 30px;
    min-height: 500px;
  }

  .cart-image img {
    width: 100%;
    height: auto;
    max-height: 450px;
    object-fit: contain;
  }

  /* Right side - Details Table */
  .cart-details {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
  }

  .cart-details h1 {
    font-size: 28px;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 30px;
    color: var(--ink);
  }

  .details-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
  }

  .details-table tr {
    border-bottom: 2px solid var(--line);
  }

  .details-table td {
    padding: 16px 12px;
    font-size: 15px;
    font-weight: 600;
    text-align: left;
  }

  .details-table .label {
    background: #f0ede9;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    width: 40%;
  }

  .details-table .value {
    background: #fff;
    color: var(--ink);
    font-weight: 500;
  }

  .details-table .value input {
    border: 1px solid var(--ink);
    padding: 8px 12px;
    font-size: 14px;
    font-family: 'Helvetica Neue', Arial, sans-serif;
    width: 100px;
  }

  .total-price {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    background: var(--accent);
    color: var(--accent-ink);
    font-size: 18px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 20px;
    border-radius: 4px;
  }

  .total-price .amount {
    font-size: 24px;
    color: var(--accent-ink);
  }

  /* Action Buttons */
  .action-buttons {
    display: flex;
    gap: 12px;
    flex-direction: column;
  }

  .btn-action {
    text-decoration: none;
    font-weight: 700;
    font-size: 14px;
    letter-spacing: 1px;
    text-transform: uppercase;
    padding: 14px 20px;
    border-radius: 4px;
    border: 2px solid var(--ink);
    cursor: pointer;
    transition: all .2s ease;
    text-align: center;
    display: block;
  }

  .btn-checkout {
    color: var(--accent-ink);
    background: var(--accent);
    border-color: var(--accent);
  }

  .btn-checkout:hover {
    background: var(--ink);
    border-color: var(--ink);
    color: var(--paper);
  }

  .btn-continue-shopping {
    color: var(--ink);
    background: transparent;
  }

  .btn-continue-shopping:hover {
    background: var(--ink);
    color: var(--paper);
  }

  .btn-remove {
    color: #d32f2f;
    background: transparent;
    border-color: #d32f2f;
  }

  .btn-remove:hover {
    background: #d32f2f;
    color: var(--paper);
  }

  /* Mobile Responsive */
  @media (max-width: 900px) {
    .cart-container {
      grid-template-columns: 1fr;
      gap: 30px;
      padding: 30px;
    }

    .cart-image {
      min-height: 350px;
    }

    .details-table .label {
      width: 50%;
    }
  }

  @media (max-width: 480px) {
    .cart-container {
      gap: 20px;
      padding: 20px;
    }

    .cart-details h1 {
      font-size: 22px;
      margin-bottom: 20px;
    }

    .details-table td {
      padding: 12px 8px;
      font-size: 13px;
    }

    .total-price {
      flex-direction: column;
      gap: 10px;
      text-align: center;
    }

    .action-buttons {
      flex-direction: column;
    }

    .btn-action {
      padding: 12px 16px;
      font-size: 12px;
    }
  }

</style>
</head>

<body>
  <nav class="navbar">
    <div class="logo"><span>Adidas</span></div>

    <div class="nav-center">
      <div class="search-bar">
        <input type="text" placeholder="Search shoes...">
        <button class="search-btn">Search</button>
      </div>
    </div>

    <div class="nav-right">
      <a href="profile.jsp" class="btn btn-login">Profile</a>
    </div>
  </nav>

  <div class="cart-container">
    <!-- Left: Product Image -->
    <div class="cart-image">
      <img src="image/adidas.jpg" alt="Nike Shoe" id="cartImage">
    </div>

    <!-- Right: Product Details -->
    <div class="cart-details">
      <h1>Summary </h1>

      <table class="details-table">
        <tr>
          <td class="label">Product Name</td>
          <td class="value">Adidas</td>
        </tr>
        <tr>
          <td class="label">Price</td>
          <!-- CHANGED: added id="unitPrice" and data-price so the script can read the plain number -->
          <td class="value" id="unitPrice" data-price="3499">$3,499</td>
        </tr>
       <tr>
          <td class="label">Delivery Charge</td>
          <!-- CHANGED: was "Free"; now shows the charge, filled in by the script -->
          <td class="value" id="deliveryCharge" data-delivery="30">$30</td>
        </tr>
        <tr>
          <td class="label">Size</td>
          <td class="value">
            <select style="border: 1px solid var(--ink); padding: 8px; font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 14px;">
              <option>Select Size</option>
              <option> UK 6</option>
              <option>UK 7</option>
              <option>UK 8</option>
              <option>UK 9</option>
              <option>UK 10</option>
              <option>UK 11</option>
              <option>UK 12</option>
            </select>
          </td>
        </tr>
        <tr>
          <td class="label">Quantity</td>
          <td class="value">
            <input type="number" min="1" max="10" value="1" id="quantity" >
          </td>
        </tr>
      </table>

      <!-- Total Price -->
      <div class="total-price">
        <span>Total Price:</span>
        <span class="amount" id="totalPrice">$3,499</span>
      </div>
	  <div class="action-buttons">
  <a href="payment.jsp" class="btn-action btn-checkout">
    BUY NOW
  </a>
</div>


    </div>
  </div>

  <!-- CHANGED: new script block added before </body> -->
  <script>
    var qtyInput  = document.getElementById('quantity');
    var totalEl   = document.getElementById('totalPrice');
    var unitPrice = Number(document.getElementById('unitPrice').getAttribute('data-price'));
    var deliveryEl = document.getElementById('deliveryCharge');
    var deliveryFee = Number(deliveryEl.getAttribute('data-delivery'));
    var currency = '$';   // change to 'Rs. ' if you want rupees shown

    function getQty() {
      var qty = parseInt(qtyInput.value, 10);
      if (isNaN(qty) || qty < 1) qty = 1;
      if (qty > 10) qty = 10;
      return qty;
    }

    function updateTotal() {
      var qty = getQty();
      // delivery charge applies when quantity is between 1 and 10
      var delivery = (qty >= 1 && qty <= 10) ? deliveryFee : 0;
      deliveryEl.textContent = currency + delivery.toLocaleString('en-US');
      totalEl.textContent = currency + (unitPrice * qty + delivery).toLocaleString('en-US');
    }

    // update total while typing or clicking the arrows
    qtyInput.addEventListener('input', updateTotal);

    // when the user leaves the box, fix invalid values (empty, 0, above 10)
    qtyInput.addEventListener('change', function () {
      qtyInput.value = getQty();
      updateTotal();
    });

    updateTotal();
  </script>

</body>
</html>
