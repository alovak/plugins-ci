require 'spec_helper'
require 'byebug'

describe 'store customer' do
  before :all do
    visit "/index.php/admin/"
    fill_in "User Name", with: "demo"
    fill_in "Password", with: "demo123"
    click_on "Login"

    wait_until do
      expect(page).to have_text("Dashboard")
    end

    # unfortunately I was not able to 'click' on
    # System / Configuration
    config_url = find("li a[href*='system_config/index']")['href']
    visit config_url

    click_on "Payment Methods"

    select "Yes", from: "Enable Test Mode"
    select "Yes", from: "Enabled"
    fill_in "Title", with: "Credit / Debit Card"
    fill_in "Test Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    fill_in "Test Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    fill_in "Live Open Key", with: "test_open_k_c3f462a1e8277114c1da"
    fill_in "Live Secret Key", with: "test_sec_k_16dc38ad730d6ba806a92"
    select "Authorize and Capture", from: "Payment Action"
    within("#content") { click_on "Save Config" }

    wait_until do
      expect(page).to have_text("The configuration has been saved.")
    end
  end

  it 'pays successfully for order' do
    visit "/index.php/demo-product.html"
    expect(page).to have_text "Demo Description"

    click_on "Add to Cart"
    expect(page).to have_content "Demo Product was added to your shopping cart."

    visit "/index.php/checkout/onepage/"

    choose "Checkout as Guest"
    click_on "Continue"

    fill_in "First Name", with: "Abdullah"
    fill_in "Last Name", with: "Ahmed"
    fill_in "Email Address", with: "start@payfort.com"
    find("input[title='Street Address']").set "In the middle of something"
    fill_in "City", with: "Dubai"
    fill_in "Telephone", with: "+1-555-555-555"
    select "United Arab Emirates", from: "Country"
    fill_in "Zip", with: "12345"
    click_on "Continue"
    sleep 1

    # shipping information
    click_on "Continue"
    sleep 1

    choose "Credit / Debit Card"

    click_on "Continue"
    sleep 1

    click_on "Place Order"
    sleep 2

    wait_until do
      expect(page).to have_text("PLEASE, WAIT WHILE WE PROCESS YOUR PAYMENT")
    end

    wait_until do
      find('iframe[name=beautifulJs]')
    end

    in_frame do
      wait_until do
        expect(page).to have_text("Secure Payment Form")
      end

      fill_inputmask('#number', '4242424242424242')
      fill_inputmask('#expiry', '11/22')
      fill_inputmask('#cvc', '123')

      click_on "Pay"
    end

    wait_until do
      expect(page).to have_content("YOUR ORDER HAS BEEN RECEIVED.")
    end
  end

  it 'receives decline when charge declined' do
    visit "/index.php/demo-product.html"
    expect(page).to have_text "Demo Description"

    click_on "Add to Cart"
    expect(page).to have_content "Demo Product was added to your shopping cart."

    visit "/index.php/checkout/onepage/"

    choose "Checkout as Guest"
    click_on "Continue"

    fill_in "First Name", with: "Abdullah"
    fill_in "Last Name", with: "Ahmed"
    fill_in "Email Address", with: "start@payfort.com"
    find("input[title='Street Address']").set "In the middle of something"
    fill_in "City", with: "Dubai"
    fill_in "Telephone", with: "+1-555-555-555"
    select "United Arab Emirates", from: "Country"
    fill_in "Zip", with: "12345"
    click_on "Continue"
    sleep 1

    # shipping information
    click_on "Continue"
    sleep 1

    choose "Credit / Debit Card"

    click_on "Continue"
    sleep 1

    click_on "Place Order"
    sleep 2

    wait_until do
      expect(page).to have_text("PLEASE, WAIT WHILE WE PROCESS YOUR PAYMENT")
    end

    in_frame do
      wait_until do
        expect(page).to have_text("Secure Payment Form")
      end

      fill_inputmask('#number', '4000000000000002')
      fill_inputmask('#expiry', '11/22')
      fill_inputmask('#cvc', '123')

      click_on "Pay"
    end

    wait_until do
      expect(page).to have_content("Charge was declined. Please, contact you bank for more information or use a different card.")
    end
  end

  def select2(value, attrs)
    first("#s2id_#{attrs[:from]}").click
    sleep(1)
    find(".select2-input").set(value)
    within ".select2-result" do
      find("span", text: value).click
    end
  end

  def fill_inputmask(location, value)
    if (Capybara.default_driver == :selenium)
      value.split('').each { |c| find(location).native.send_keys(c) }
    else
      script = "$('#{location}').val('#{value}');"
      page.evaluate_script(script)
    end
  end

  def in_frame(&block)
    if (Capybara.default_driver == :selenium)
      within_frame(find('iframe[name=beautifulJs]'), &block)
    else
      yield
    end
  end

  def wait_until
    attempts ||= 5
    yield
  rescue Exception
    sleep 1
    puts "retry..."
    (attempts -= 1).zero? ? raise : retry
  end
end
