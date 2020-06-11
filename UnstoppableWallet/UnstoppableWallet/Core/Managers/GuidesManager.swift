import Foundation

class GuidesManager {
}

extension GuidesManager: IGuidesManager {

    var guides: [Guide] {
        [
            Guide(
                    title: "Tether in Simple Terms",
                    date: Date(),
                    imageUrl: "https://raw.githubusercontent.com/horizontalsystems/blockchain-crypto-guides/master/token_guides/images/usdt-Main-l.png",
                    fileName: "tether"
            ),
            Guide(
                    title: "MakerDAO & DAI in Simple Terms",
                    date: Date(),
                    imageUrl: "https://raw.githubusercontent.com/horizontalsystems/blockchain-crypto-guides/master/token_guides/images/mkr-Main-l.png",
                    fileName: "maker"
            ),
            Guide(
                    title: "Bitcoin In Simple Terms",
                    date: Date(),
                    imageUrl: "https://media.gettyimages.com/photos/530d-car-head-lights-picture-id157735154",
                    fileName: "bitcoin"
            ),
            Guide(
                    title: "Ethereum in Simple Terms",
                    date: Date(),
                    imageUrl: "http://media.gettyimages.com/photos/modern-key-to-the-bmw-in-a-hand-picture-id890886864",
                    fileName: "ethereum"
            ),
        ]
    }

}