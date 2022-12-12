defmodule Utils.SuffixArrayBenchmarkDriver do

  def run_benchmark() do
    {:ok, trigrams} = File.read("data/inputs/suffix_array/trigrams")
    {:ok, dna} = File.read("data/inputs/suffix_array/chr22_small.dna")

    plist = [2, 4, 6, 12, 24, 32, 40]

    impl_map = Enum.flat_map(plist, fn p ->
      [
        {"parallel;p=#{p};trigrams", fn () -> NaiveParallelSuffixArray.suffix_array(trigrams, p) end},
        {"parallel;p=#{p};dna", fn () -> NaiveParallelSuffixArray.suffix_array(dna, p) end},
      ]
    end)
    |> Map.new()
    |> Map.put("serial;trigrams", fn () -> SequentialSuffixArray.suffix_array(trigrams) end)
    |> Map.put("serial;dna", fn () -> SequentialSuffixArray.suffix_array(dna) end)

    Benchee.run(
      impl_map,
      time: 60,
      formatters: [
        {Benchee.Formatters.CSV, file: "output_suffix_array.csv"}
      ]
    )
  end
end
