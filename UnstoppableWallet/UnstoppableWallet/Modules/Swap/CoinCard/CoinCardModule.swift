import UniswapKit
import RxSwift

protocol ISwapCoinCardService: AnyObject {
    var isEstimated: Bool { get }
    var amount: Decimal? { get }
    var coin: Coin? { get }
    var balance: Decimal? { get }

    var isEstimatedObservable: Observable<Bool> { get }
    var amountObservable: Observable<Decimal?> { get }
    var coinObservable: Observable<Coin?> { get }
    var balanceObservable: Observable<Decimal?> { get }
    var errorObservable: Observable<Error?> { get }

    func onChange(amount: Decimal?)
    func onChange(coin: Coin)
}

struct CoinCardModule {

    static func fromCell(service: SwapService, tradeService: SwapTradeService) -> SwapCoinCardCell {
        let fiatService = FiatService(currencyKit: App.shared.currencyKit, rateManager: App.shared.rateManager)
        let viewModel = SwapCoinCardViewModel(
                coinCardService: FromCoinCardService(service: service, tradeService: tradeService),
                fiatService: fiatService,
                decimalParser: AmountDecimalParser()
        )
        return SwapCoinCardCell(viewModel: viewModel, title: "swap.you_pay".localized)
    }

    static func toCell(service: SwapService, tradeService: SwapTradeService) -> SwapCoinCardCell {
        let fiatService = FiatService(currencyKit: App.shared.currencyKit, rateManager: App.shared.rateManager)
        let viewModel = SwapCoinCardViewModel(
                coinCardService: ToCoinCardService(service: service, tradeService: tradeService),
                fiatService: fiatService,
                decimalParser: AmountDecimalParser()
        )
        return SwapCoinCardCell(viewModel: viewModel, title: "swap.you_get".localized)
    }

}

class FromCoinCardService: ISwapCoinCardService {
    private let cardType: TradeType = .exactIn
    private let service: SwapService
    private let tradeService: SwapTradeService

    init(service: SwapService, tradeService: SwapTradeService) {
        self.service = service
        self.tradeService = tradeService
    }

    var isEstimated: Bool { tradeService.tradeType != cardType }
    var amount: Decimal? { tradeService.amountIn }
    var coin: Coin? { tradeService.coinIn }
    var balance: Decimal? { service.balanceIn }

    var isEstimatedObservable: Observable<Bool> { tradeService.tradeTypeObservable.map { $0 != cardType } }
    var amountObservable: Observable<Decimal?> { tradeService.amountInObservable }
    var coinObservable: Observable<Coin?> { tradeService.coinInObservable }
    var balanceObservable: Observable<Decimal?> { service.balanceInObservable }
    var errorObservable: Observable<Error?> {
        service.errorsObservable.map {
            $0.first(where: { .insufficientBalanceIn == $0 as? SwapService.SwapError })
        }
    }

    func onChange(amount: Decimal?) {
        tradeService.set(amountIn: amount)
    }

    func onChange(coin: Coin) {
        tradeService.set(coinIn: coin)
    }

}

class ToCoinCardService: ISwapCoinCardService {
    private let cardType: TradeType = .exactOut
    private let service: SwapService
    private let tradeService: SwapTradeService

    init(service: SwapService, tradeService: SwapTradeService) {
        self.service = service
        self.tradeService = tradeService
    }

    var isEstimated: Bool { tradeService.tradeType != cardType }
    var amount: Decimal? { tradeService.amountOut }
    var coin: Coin? { tradeService.coinOut }
    var balance: Decimal? { service.balanceOut }

    var isEstimatedObservable: Observable<Bool> { tradeService.tradeTypeObservable.map { $0 != cardType } }
    var amountObservable: Observable<Decimal?> { tradeService.amountOutObservable }
    var coinObservable: Observable<Coin?> { tradeService.coinOutObservable }
    var balanceObservable: Observable<Decimal?> { service.balanceOutObservable }
    var errorObservable: Observable<Error?> {
        Observable<Error?>.just(nil)
    }

    func onChange(amount: Decimal?) {
        tradeService.set(amountOut: amount)
    }

    func onChange(coin: Coin) {
        tradeService.set(coinOut: coin)
    }

}
