# frozen_string_literal: true

RSpec.describe Keepr::GroupsCreator do
  context 'balance groups in german' do
    before do
      described_class.new(:balance).run
    end

    it 'creates groups' do
      expect(Keepr::Group.count).to eq(64)
      expect(Keepr::Group.asset.count).to eq(36)
      expect(Keepr::Group.liability.count).to eq(28)

      compare_with_source(Keepr::Group.asset, 'de', 'asset.txt')
      compare_with_source(Keepr::Group.liability, 'de', 'liability.txt')
    end

    it 'creates result group' do
      expect(Keepr::Group.result).to be_a(Keepr::Group)
    end
  end

  context 'profit & loss groups' do
    before do
      described_class.new(:profit_and_loss).run
    end

    it 'creates profit & loss groups' do
      expect(Keepr::Group.count).to eq(31)
      expect(Keepr::Group.profit_and_loss.count).to eq(31)

      compare_with_source(Keepr::Group.profit_and_loss, 'de', 'profit_and_loss.txt')
    end
  end

  private

  def compare_with_source(scope, language, filename)
    full_filename = File.join(File.dirname(__FILE__), "../../lib/keepr/groups_creator/#{language}/#{filename}")
    source = File.read(full_filename)

    lines = scope.find_each.map { |g| "#{' ' * g.depth * 2}#{g.number} #{g.name}\n" }.join

    expect(lines).to eq(source)
  end
end
