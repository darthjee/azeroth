# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator::KeyValueExtractor do
  subject(:extractor) do
    described_class.new(decorator, attribute, options)
  end

  let(:decorator_class) { Class.new(Azeroth::Decorator) }
  let(:decorator)       { decorator_class.new(object)}
  let(:object)          { create(:document) }
  let(:attribute)       { :name }
  let(:options_hash)    { {} }
  let(:options) do
    Azeroth::Decorator::Options.new(options_hash)
  end


  describe '#as_json' do
    context 'with default options' do
      it 'returns attribute and value as hash' do
        expect(extractor.as_json)
          .to eq({ 'name' => object.name })
      end
    end

    context "with 'as' option" do
      let(:options_hash) { { as: :the_name } }

      it 'uses new given key' do
        expect(extractor.as_json)
          .to eq({ 'the_name' => object.name })
      end
    end

    context "with 'if' option" do
      context 'with symbol' do
        let(:options_hash) { { if: :magic? } }
        let(:decorator_class) { Document::Decorator }

        context 'when decorator method returns true' do
          let(:object)  { create(:document, reference: 'X-MAGIC-1') }

          it 'returns attribute and value as hash' do
            expect(extractor.as_json)
              .to eq({ 'name' => object.name })
          end
        end

        context 'when decorator method returns false' do
          it do
            expect(extractor.as_json)
              .to be_a(Hash)
          end

          it do
            expect(extractor.as_json)
              .to be_empty
          end
        end
      end

      context 'with Proc resolving to true' do
        let(:options_hash) do
          {
            if: proc do |decorator|
              decorator.name == object.name
            end
          }
        end

        it do
          expect(extractor.as_json)
            .to eq({ 'name' => object.name })
        end
      end

      context 'with Proc resolving to false' do
        let(:options_hash) do
          {
            if: proc do |decorator|
              decorator.name != object.name
            end
          }
        end

        it do
          expect(extractor.as_json)
            .to be_a(Hash)
        end

        it do
          expect(extractor.as_json)
            .to be_empty
        end
      end
    end
  end
end
