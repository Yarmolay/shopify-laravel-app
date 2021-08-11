@extends('shopify-app::layouts.default')

@section('content')
    <!-- You are: (shop domain name) -->
    <p>You are: {{ $shopDomain ?? Auth::user()->name }}</p>
@endsection

@section('scripts')
    @parent

    <script>
        actions.TitleBar.create(app, { title: 'Welcome' });
    </script>
@endsection

<main>
    <?php
        $shop = Auth::user();

         $products = $shop->api()->rest('GET', '/admin/api/2021-01/products.json', ['limits' => 5]);
         $products = $products['body']['container']['products'];

         if ($products) {
            foreach($products as $product) {
                print_r($product);
                echo '<br>';
            }
         }
         

        
    ?>
</main>
