SELECT
  -- Geography & Store
  country,
  retailer_code,
  retailer_name AS retailer,
  type AS store_type,
  -- Product
  product_brand,
  product_line,
  product_type,
  ds.product_number,
  product AS product_name,
  -- Channel
  order_method_type,
  -- Transaction info
  date,
  quantity,
  -- Pricing (self cost (without profit), full price, sale price (with discount))
  unit_cost,
  ds.unit_price AS unit_full_price,
  unit_sale_price,
  -- Discount
  ROUND(ds.unit_price - unit_sale_price, 2) AS discount,
  ROUND( SAFE_DIVIDE(ds.unit_price - unit_sale_price, ds.unit_price) * 100, 2) AS discount_rate,
  -- Unit margin
  ROUND(unit_sale_price - unit_cost, 2) AS unit_margin,
  -- Revenue & Cost
  ROUND(quantity * unit_sale_price, 2) AS revenue,
  ROUND(quantity * unit_cost, 2) AS total_cost,
  -- Profit
  ROUND(quantity * (unit_sale_price - unit_cost), 2) AS profit,
  -- Profit margin %
  ROUND(SAFE_DIVIDE(quantity * (unit_sale_price - unit_cost),quantity * unit_sale_price),2) AS profit_margin,
  -- Average selling price 
  unit_sale_price AS avg_selling_price,
  -- Revenue per store (global benchmark metric)
  ROUND(SAFE_DIVIDE(quantity * unit_sale_price,COUNT(DISTINCT retailer_code) OVER ()),2) AS revenue_per_store,
  -- Revenue per product (portfolio benchmark)
  ROUND(SAFE_DIVIDE(quantity * unit_sale_price,COUNT(DISTINCT ds.product_number) OVER ()),2) AS revenue_per_product,

FROM `GoExplore_pro_data.daily_sales` AS ds
JOIN `GoExplore_pro_data.methods` USING (order_method_code)
JOIN `GoExplore_pro_data.products` USING (product_number)
JOIN `GoExplore_pro_data.retailers` USING (retailer_code)

ORDER BY date;

