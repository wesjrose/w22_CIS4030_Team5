import '../models/product.dart';

class ProductInfo {
  static List<Product> productInfo = [
    Product(
        name:
            'EVGA GeForce RTX 3080 Ti FTW3 Ultra Gaming 12GB GDDR6X Video Card',
        price: '1949.99',
        manufacturer: 'EVGA',
        imageURL:
            'https://images.evga.com/products/gallery/png/12G-P5-3967-KR_LG_1.png',
        description:
            'Enjoy super smooth 4K gaming with this EVGA GeForce RTX 3080 Ti FTW3 ultra gaming video card. It features 12GB of GDDR6X memory, improved RT and Tensor cores, and DirectX 12 Ulimate to guarantee amazing gaming experience. EVGA ICX3 Technology keeps the critical components at optimal temperature and the all-metal backplate improves the durability of the video card.',
        availableStores: [
          "Best Buy Oakville",
          "Best Buy Guelph",
          "Best Buy Kitchener",
          "Amazon",
        ],
        id: 0,
        type: "GPU"),
    Product(
        name: 'MSI AMD Radeon RX 6800 XT GAMING X TRIO 16 GB GDDR6 Video Card',
        price: '1619.99',
        manufacturer: 'MSI',
        imageURL:
            'https://asset.msi.com/resize/image/global/product/product_1605516436d3924f866b29dfd4d11602bb12d44a20.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png',
        description:
            'Take your PC gaming to the next level with the MSI AMD Radeon RX 6800 XT graphics card. It has 16GB of 2000MHz video RAM to support resolutions up to 7680 x 4320, and a 2285MHz clock speed that can handle marathon gaming sessions. Its DirectX12 Ultimate gives game developers the power to deliver immersive visuals and take their games to the next level.',
        availableStores: [
          "Best Buy Brampton",
          "Best Buy Orangeville",
          "Best Buy Toronto",
        ],
        id: 1,
        type: "GPU"),
    Product(
        name: 'Intel Core i5-12600K Octa-Core 3.7GHz Processor',
        price: '369.99',
        manufacturer: 'Intel',
        imageURL:
            'https://c1.neweggimages.com/ProductImageCompressAll1280/19-118-347-05.jpg',
        description:
            'Take your PC gaming to the next level with the MSI AMD Radeon RX 6800 XT graphics card. It has 16GB of 2000MHz video RAM to support resolutions up to 7680 x 4320, and a 2285MHz clock speed that can handle marathon gaming sessions. Its DirectX12 Ultimate gives game developers the power to deliver immersive visuals and take their games to the next level.',
        availableStores: [
          "Best Buy Brampton",
          "Best Buy Orangeville",
          "Best Buy Toronto",
        ],
        id: 2,
        type: "CPU"),
    Product(
        name: 'Intel Core i5-12600K Octa-Core 3.7GHz Processor',
        price: '369.99',
        manufacturer: 'Intel',
        imageURL:
            'https://m.media-amazon.com/images/I/71Q2Vcw-wlL._AC_SL1500_.jpg',
        description:
            "The world's most advanced processor in the desktop PC gaming segment. Max Temps: 95°C. Can deliver ultra-fast 100+ FPS performance in the world's most popular games. Base Clock 3.6GHz. 8 Cores and 16 processing threads, bundled with the AMD Wraith Prism cooler with color-controlled LED support. 4.4 GHz Max Boost, unlocked for overclocking, 36 MB of game Cache, ddr-3200 support; Default TDP: 65W. For the advanced socket AM4 platform, can support PCIe 4.0 on x570 motherboards",
        availableStores: [
          "Best Buy London",
          "Best Buy Oakville",
          "Best Buy Toronto",
          "Amazon",
        ],
        id: 3,
        type: "CPU"),
  ];
}
