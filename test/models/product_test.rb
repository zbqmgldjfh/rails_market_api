require "test_helper"

class ProductTest < ActiveSupport::TestCase

  test "상품의 가격은 양수여야 합니다" do
    product = products(:one)
    product.price = -1

    assert_not product.valid?
  end

  test "상품 이름으로 제품을 필터링 해야한다" do
    assert_equal 2, Product.filter_by_title("tv").count
  end

  test "상품 이름으로 제품을 필터링 하고 정렬해야 한다" do
    assert_equal [products(:another_tv), products(:one)], Product.filter_by_title("tv").sort
  end

  test "상품 가격으로 제품을 필터링 하고 정렬해야 한다" do
    assert_equal [products(:two), products(:one)], Product.above_or_equal_to_price(200).sort
  end

  test "더 낮은 가격을 기준으로 제품을 필터링하고 정렬해야 한다" do
    assert_equal [products(:another_tv)], Product.below_or_equal_to_price(200).sort
  end

  test "recent 호출 시 최신순으로 정렬" do
    products(:two).touch

    assert_equal [products(:another_tv), products(:one), products(:two)], Product.recent.to_a
  end

  test '"videogame" 과 최소금앤이 "100"인 경우 검색결과가 없다' do
    search_hash = { keyword: 'videogame', min_price: 100 }
    assert Product.search(search_hash).empty?
  end

  test 'TV검색시 Cheap TV가 검색된다' do
    search_hash = { keyword: 'tv', min_price: 50, max_price: 150 }
    assert_equal [products(:another_tv)], Product.search(search_hash)
  end

  test '파라미터가 없는 경우 모든 상품을 반환한다' do
    assert_equal Product.all.to_a, Product.search({})
  end

  test '검색을 상품 id로도 할 수 있다' do
    search_hash = { product_ids: [products(:one).id] }
    assert_equal [products(:one)], Product.search(search_hash)
  end
end
