shared_examples 'definition dsl movement' do |type|
  describe "##{type}" do
    it "raises error with no tenant" do
      expect_error_in_class_definition("'#{type}' needs to run inside 'entry' block") do
        include Ledgerizer::Definition::Dsl

        send(type, account: nil, accountable: nil)
      end
    end

    it "raises error with no entry" do
      expect_error_in_class_definition("'#{type}' needs to run inside 'entry' block") do
        include Ledgerizer::Definition::Dsl

        tenant('portfolio') do
          send(type, account: nil, accountable: nil)
        end
      end
    end

    it "raises error with no defined account" do
      expect_error_in_class_definition("the cash account does not exist in tenant") do
        include Ledgerizer::Definition::Dsl

        tenant('portfolio') do
          entry(:deposit, document: 'portfolio') do
            send(type, account: :cash, accountable: nil)
          end
        end
      end
    end

    it "raises error with invalid accountable" do
      expect_error_in_class_definition("accountable must be an ActiveRecord model name") do
        include Ledgerizer::Definition::Dsl

        tenant('portfolio') do
          asset(:cash)

          entry(:deposit, document: 'portfolio') do
            send(type, account: :cash, accountable: 'invalid')
          end
        end
      end
    end

    context "with valid #{type}" do
      let_definition_class do
        tenant('portfolio') do
          asset(:cash)

          entry(:deposit, document: :portfolio) do
            send(type, account: :cash, accountable: :user)
          end
        end
      end

      let(:expected) do
        {
          tenant_class: :portfolio,
          entry_code: :deposit,
          movement_type: type,
          account: :cash,
          accountable: :user
        }
      end

      it { expect(LedgerizerTestDefinition).to have_ledger_movement_definition(expected) }
    end

    context "with multiple movements" do
      let_definition_class do
        tenant('portfolio') do
          asset(:cash)
          asset(:bank)

          entry(:deposit, document: :portfolio) do
            send(type, account: :cash, accountable: :user)
            send(type, account: :bank, accountable: :user)
          end
        end
      end

      let(:expected_cash) do
        {
          tenant_class: :portfolio,
          entry_code: :deposit,
          movement_type: type,
          account: :cash,
          accountable: :user
        }
      end

      let(:expected_bank) do
        {
          tenant_class: :portfolio,
          entry_code: :deposit,
          movement_type: type,
          account: :bank,
          accountable: :user
        }
      end

      it { expect(LedgerizerTestDefinition).to have_ledger_movement_definition(expected_cash) }
      it { expect(LedgerizerTestDefinition).to have_ledger_movement_definition(expected_bank) }
    end

    context "with movements in multiple entries" do
      let_definition_class do
        tenant('portfolio') do
          asset(:cash)
          asset(:bank)

          entry(:deposit, document: :portfolio) do
            send(type, account: :cash, accountable: :user)
            send(type, account: :bank, accountable: :user)
          end

          entry(:distribute, document: :portfolio) do
            send(type, account: :cash, accountable: :user)
          end
        end
      end

      let(:expected_cash) do
        {
          tenant_class: :portfolio,
          entry_code: :deposit,
          movement_type: type,
          account: :cash,
          accountable: :user
        }
      end

      let(:expected_bank) do
        {
          tenant_class: :portfolio,
          entry_code: :deposit,
          movement_type: type,
          account: :bank,
          accountable: :user
        }
      end

      let(:expected_cash1) do
        {
          tenant_class: :portfolio,
          entry_code: :distribute,
          movement_type: type,
          account: :cash,
          accountable: :user
        }
      end

      it { expect(LedgerizerTestDefinition).to have_ledger_movement_definition(expected_cash) }
      it { expect(LedgerizerTestDefinition).to have_ledger_movement_definition(expected_bank) }
      it { expect(LedgerizerTestDefinition).to have_ledger_movement_definition(expected_cash1) }
    end
  end
end
