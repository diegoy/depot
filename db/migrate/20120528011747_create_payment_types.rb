class CreatePaymentTypes < ActiveRecord::Migration
  def up
    create_table :payment_types do |t|
      t.string :name

      t.timestamps
    end

    PaymentType.create(name: 'Check')
    PaymentType.create(name: 'Credit Card')
    PaymentType.create(name: 'Purchase Order')

    add_column :orders, :payment_type_id, :integer
    Order.reset_column_information
    Order.all.each do |order|
      order.payment_type_id = case order.pay_type
                              when 'Check'
                                1
                              when 'Credit Card'
                                2
                              when 'Purchase Order'
                                3
                              else 0
                              end
      order.save validate: false
    end
    Order.reset_column_information
    remove_column :orders, :pay_type
  end

  def down
    add_column :orders, :pay_type, :string
    Order.reset_column_information
    Order.all.each do |order|
      order.pay_type = case order.payment_type_id
                       when 1
                         'Check'
                       when 2
                         'Credit Card'
                       when 3
                         'Purchase Order'
                       else
                         'Credit Card'
                       end
      order.payment_type_id = 0
      order.save validate: false
    end
    Order.reset_column_information
    drop_table :payment_types
    remove_column :orders, :payment_type_id
  end

end
