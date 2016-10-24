use "ponytest"
use "wallaroo/messages"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestOriginSet)
    test(_TestHashOriginRoute)
    test(_TestHighWatermarkTable)


class _TestOrigin is Origin 
  let _hwm: HighWatermarkTable = HighWatermarkTable(10)
  let _lwm: LowWatermarkTable = LowWatermarkTable(10)
  let _translate: TranslationTable = TranslationTable(10)
  let _origins: OriginSet = OriginSet(10)

  fun ref _hwm_get(): HighWatermarkTable
  =>
    _hwm
  
  fun ref _lwm_get(): LowWatermarkTable
  =>
    _lwm
    
  fun ref _translate_get(): TranslationTable
  =>
    _translate
  
  fun ref _origins_get(): OriginSet
  =>
    _origins


class iso _TestOriginSet is UnitTest
  fun name(): String =>
    "messages/OriginSet"

  fun apply(h: TestHelper) =>
    let set = OriginSet(1)
    let o1: Origin = _TestOrigin
    set.set(o1)
    h.assert_true(set.contains(o1))

class iso _TestHashOriginRoute is UnitTest
  fun name(): String =>
    "messages/HashOriginRoute"

  fun apply(h: TestHelper) =>
    let origin: Origin = _TestOrigin
    let route: U64 = U64(1)
    let pair: OriginRoutePair = (origin, route)
    let hash1: U64 = HashOriginRoute.hash(pair)
    let hash2: U64 = HashOriginRoute.hash(pair)
    h.assert_true(hash1 == hash2)
    h.complete(HashOriginRoute.eq(pair, pair))
    
    
class iso _TestHighWatermarkTable is UnitTest
  fun name(): String =>
    "messages/HighWatermarkTable"

  fun apply(h: TestHelper) =>
    let hwm: HighWatermarkTable = HighWatermarkTable(10)
    let origin: Origin = _TestOrigin
    let route: U64 = U64(1)
    let pair: OriginRoutePair = (origin, route)
    let seq_id: U64 = U64(100)
    hwm.update(pair, seq_id)

    try
      let result = hwm(pair)
      h.assert_true(result == seq_id)
    else
      h.fail("HighWatermarkTable lookup failed!")
    end
    
  fun timed_out(h: TestHelper) =>
    h.complete(false)



    // h.complete(false)
    // h.fail("test failed")
    // h.long_test(5_000_000_000)


