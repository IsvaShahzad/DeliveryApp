import 'package:cloud_firestore/cloud_firestore.dart';

// Example of a Firebase Stream
Stream<QuerySnapshot> get categoriesStream =>
    FirebaseFirestore.instance.collection('categories').snapshots();

// User's default name
String userFirstName = 'User'; // Default name if fetching fails

List<String> imagePathsAllRestaurant = [
  'assets/images/tile1.jpeg',
  'assets/images/tile2.jpeg',
  'assets/images/tile3.jpeg',
  'assets/images/tile4.jpeg',
  'assets/images/tile5.jpeg',
  'assets/images/tile6.jpeg',
  'assets/images/tile7.jpeg',
  'assets/images/tile8.jpeg',
  'assets/images/tile9.jpeg',
  'assets/images/tile10.jpeg',
  // Add more image paths here
];
List<String> imagePathsStart = [
  'assets/images/Fastdelivery.png',
  'assets/images/ad4.png',
  'assets/images/ad2.png',
  'assets/images/ad.png',
];

List<String> imagePathsHotDeals = [
  'https://img.freepik.com/premium-photo/flying-french-fries-with-salt-shower-playful-food-photography_879656-720.jpg',
  'https://tb-static.uber.com/prod/image-proc/processed_images/82877ef93503c3d6bcfdbb7579e6d091/3ac2b39ad528f8c8c5dc77c59abb683d.jpeg',
  'https://cdn.shopify.com/s/files/1/2289/1873/files/warm_plate-min.jpg?v=1668949150',
  'https://www.shlomosaspen.com/wp-content/uploads/2023/04/american-deli-style-food.jpeg',
  'https://www.verywellfit.com/thmb/BrdrHtuMT1hNWP8s0EZIZ36UrdY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/summermeals-150b10ac132446b1becac4a463ee6a25.jpg',
  'https://www.capetourism.com/wp-content/uploads/2023/07/bestburgersincapetown-1-1000x570.jpg',
  'https://recipe30.com/wp-content/uploads/2022/07/Shawarma.jpg',
];

final List<String> titlesCuisineForYou = [
  'Pizza',
  'Burgers',
  'Biryaani',
  'Desserts',
  'Fast Food',
  'Pasta',
  'Chinese',
  'Ice cream',
  'BBQ',
  'Shakes',
  'Salads',
];
final List<String> titlesHotDeals = [
  'Tasty Spot',
  'Food Corner',
  'Hot Plates',
  'Taste Deli',
  'Meal Place',
  'Fresh Bites',
  'Snack Bar',
];
final List<String> imagepathDesiDesire = [
  'https://www.zameen.com/blog/wp-content/uploads/2019/04/image-3-7-1024x640.jpg',
  'https://silverspoononline.com/wp-content/uploads/2022/08/5-desi-food-items-you-cannot-live-without.jpg',
  'https://i0.wp.com/dinepartner.com/blog/wp-content/uploads/2019/05/01.png?fit=630%2C315&ssl=1',
  'https://zameenblog.s3.amazonaws.com/blog/wp-content/uploads/2021/04/foodkarachi1.jpg',
  'https://www.foodandwine.com/thmb/8YAIANQTZnGpVWj2XgY0dYH1V4I=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/spicy-chicken-curry-FT-RECIPE0321-58f84fdf7b484e7f86894203eb7834e7.jpg',
  'https://www.recipesaresimple.com/wp-content/uploads/2013/02/Mughlai-Chicken-how-to-make.jpg',
];



final List<String> titleDesiDesire = [
  'Desi Delights Diner',
  'Heritage Spice Lounge',
  'Desi Delights Diner',
  'Corner Café',
  'Royal Curry',
  'Mughal Garden',
];



final List<String> imagePathsCuisinesForYou = [
  'https://www.cookingcarnival.com/wp-content/uploads/2019/11/Paneer-Pizza-7.jpg',
  'https://www.shutterstock.com/image-photo/burger-tomateoes-lettuce-pickles-on-600nw-2309539129.jpg',
  'https://c.ndtvimg.com/2022-04/fq5cs53_biryani-doubletree-by-hilton_625x300_12_April_22.jpg',
  'https://www.tasteofhome.com/wp-content/uploads/2018/01/Cherry-Delight-Dessert_EXPS_TOHcom23_27515_P2_MD_03_22_4b.jpg',
  'https://www.partstown.com/about-us/wp-content/uploads/2023/11/what-is-considered-fast-food.jpg',
  'https://feelgoodfoodie.net/wp-content/uploads/2023/04/Pasta-Bolognese-TIMG.jpg',
  'https://s.hdnux.com/photos/01/35/47/05/24539488/1/1082x0.jpg',
  'https://cdn.britannica.com/50/80550-050-5D392AC7/Scoops-kinds-ice-cream.jpg',
  'https://zameenblog.s3.amazonaws.com/blog/wp-content/uploads/2021/07/2-10-1024x640.jpg',
  'https://bhg.com/thmb/QnT7M8Wi5ed4HVEFZ2nMd_lhiUM=/1920x0/filters:no_upscale():strip_icc()/RU295238-5d5e1260f8ab4361bbc6f598594d967b.jpg',
  'https://img.bestrecipes.com.au/L2EzsaO5/w643-h428-cfill-q90/br/2017/02/thai-chicken-meatball-salad-517916-1.jpg',
];

List<String> titlesMain = [
  'The Flavour Forge',
  'Spice Caravan',
  'The Green Plate',
  'Midnight Munchies',
  'Cloud Nine Cafe',
  'Melting Pot',
  'BakesCo.',
  'Secret Ingredient',
  'Salt & Spice',
  'Sweet Crema',
  // Add more titles here
];

Map<String, List<Map<String, dynamic>>> products = {
  'The Flavour Forge': [
    {
      'name': 'Classic Cheese Burger',
      'price': 900.0,
      'description':
          'Beef patty, cheddar cheese, lettuce, tomato, pickles, ketchup, mustard, bun.',
      'image':
          'https://assets.epicurious.com/photos/5c745a108918ee7ab68daf79/1:1/w_2560%2Cc_limit/Smashburger-recipe-120219.jpg',
    },
    {
      'name': 'Jalapeno Burger',
      'price': 850.0,
      'description':
          'Beef patty, pepper jack cheese, sliced jalapeños, lettuce, tomato, spicy condiments, bun.',
      'image':
          'https://thefoodieandthefix.com/wp-content/uploads/2018/07/DSC_7680-7.jpg',
    },
    {
      'name': 'Mushroom Swiss Burger',
      'price': 1000.0,
      'description':
          'Beef patty, Swiss cheese, sautéed mushrooms, lettuce, tomato, onion, bun.',
      'image':
          'https://recipes.net/wp-content/uploads/2023/05/mushroom-brie-burger_2fd48179bfd37a2b6dbf014780cf44f4.jpeg',
    },
    {
      'name': 'BBQ Burger',
      'price': 700.0,
      'description':
          'Beef patty, cheddar cheese, BBQ sauce, onion rings, pickles, bun.',
      'image':
          'https://dudethatcookz.com/wp-content/uploads/2020/04/Double_BBQ_Cheddar_Burger14_Hero.jpg',
      // 'category': 'Burgers',
    },
    {
      'name': 'Grilled Chicken Burger',
      'price': 650.0,
      'description':
          'Grilled chicken breast, lettuce, tomato, onion, pickles, mayonnaise, mustard, salt, pepper, burger bun.',
      'image':
          'https://www.brakebush.com/wp-content/uploads/5702-Chicken-Burger-3.jpg',
      // 'category': 'Burgers',
    },
    {
      'name': 'Turkey Burger',
      'price': 1300.0,
      'description': 'Turkey patty, lettuce, tomato, pickles, condiments, bun.',
      'image':
          'https://allthehealthythings.com/wp-content/uploads/2023/06/Greek-Chicken-Burgers-6-scaled.jpg',
    },
    {
      'name': 'Lamb Burger',
      'price': 1500.0,
      'description':
          'Ground lamb patty, tzatziki sauce, cucumber, tomato, bun.',
      'image':
          'https://www.jocooks.com/wp-content/uploads/2016/06/greek-lamb-burgers-1-3.jpg',
    },
    {
      'name': 'Egg Burger',
      'price': 450.0,
      'description':
          'Fried egg, cheese (optional), lettuce, tomato, onion, bacon (optional), salt, pepper, condiments, burger bun.',
      'image':
          'https://i0.wp.com/dashofsavory.com/wp-content/uploads/2018/05/IMG_99201.jpg?fit=2000%2C1334&ssl=1',
    },
    {
      'name': 'Sliders',
      'price': 350.0,
      'description':
          'Mini beef or chicken patties, various toppings (lettuce, tomato, cheese, pickles, condiments), small buns.',
      'image':
          'https://www.thevegspace.co.uk/wp-content/uploads/2011/11/FV-Insta-4.jpg',
    },
    {
      'name': 'Loaded Cheese Fries',
      'price': 500.0,
      'description':
          'Fries, cheddar cheese, bacon bits, sour cream, green onions, shredded cheese, salt, black pepper.',
      'image':
          'https://img.taste.com.au/YrGqJasN/w720-h480-cfill-q80/taste/2017/09/hot-chips-loaded-up-with-stuff-130602-2.jpg',
      // 'category': 'Fries',
    },
    {
      'name': 'Plain Fries',
      'price': 300.0,
      'description':
          'Fries, salt, black pepper, ketchup or preferred dipping sauce.',
      'image':
          'https://www.allrecipes.com/thmb/stn7IXofvVqnlXyaQVAHLVwux0A=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/50223-homemade-crispy-seasoned-french-fries-DDMFS-4x3-4e3f07ae55c9474abc0e4ce601c33eda.jpg',
    },
    {
      'name': 'Jalapeno Cheese Fries',
      'price': 450.0,
      'description':
          'Fries, cheddar cheese, sliced jalapenos, sour cream, green onions, salt, black pepper.',
      'image':
          'https://media-cdn.tripadvisor.com/media/photo-s/1c/50/c0/ef/jalapeno-cheese-fries.jpg',
    },
    {
      'name': 'Garlic Mayo Fries',
      'price': 350.0,
      'description': 'Garlic Mayo sauce, salt and pepper ',
      'image': 'https://i.ytimg.com/vi/-yoo47nxVq4/maxresdefault.jpg',
    },
    {
      'name': 'Buffalo Wings',
      'price': 800.0,
      'description':
          'Chicken wings, hot sauce, butter, vinegar, garlic powder, paprika, salt, pepper.',
      'image':
          'https://www.kitchensanctuary.com/wp-content/uploads/2019/09/Buffalo-Wings-square-FS-55.jpg',
    },
    {
      'name': 'Honey BBQ Wings',
      'price': 600.0,
      'description':
          '  Chicken wings, BBQ sauce, honey, garlic powder, onion powder, paprika, salt, pepper.',
      'image':
          'https://www.smoking-meat.com/image-files/honey-barbecue-smoked-wings-575x384-1.jpg',
    },
    {
      'name': 'Tereyaki Wings',
      'price': 800.0,
      'description':
          'Chicken wings, teriyaki sauce, soy sauce, honey, garlic, ginger, sesame seeds, green onions.',
      'image':
          'https://healthyrecipesblogs.com/wp-content/uploads/2021/08/teriyaki-chicken-wings-featured-2022.jpg',
      // 'category': 'Wings',
    },
    {
      'name': 'Sriracha Honey Wings',
      'price': 750.0,
      'description':
          'Chicken wings, Sriracha sauce, honey, soy sauce, garlic powder, ginger powder, sesame oil, lime juice.',
      'image':
          'https://simply-delicious-food.com/wp-content/uploads/2015/10/Sriracha-honey-wings-1.jpg',
    },
    {
      'name': 'Cajun Wings',
      'price': 700.0,
      'description': 'Chicken wings, Cajun seasoning, olive oil, salt, pepper.',
      'image':
          'https://cookingupmemories.com/wp-content/uploads/2020/11/Delicious-Cajun-Wings--scaled.jpg',
    },
    {
      'name': 'Buffalo Ranch Wings',
      'price': 650.0,
      'description':
          'Chicken wings, buffalo sauce, ranch seasoning mix, butter, garlic powder, onion powder, salt, pepper.',
      'image':
          'https://www.hiddenvalley.com/wp-content/uploads/2021/04/ranch-buffalo-wings-RDP.jpg',
    },
  ],

  'Spice Caravan': [
    {'name': 'Spicy Tacos', 'price': 10.99},
    {'name': 'Chili Nachos', 'price': 9.99},
  ],
  // Add more products for each restaurant

  'Tasty Spot': [
    {'name': 'Spicy Tacos', 'price': 10.99},
    {'name': 'Chili Nachos', 'price': 9.99},
  ],
};
