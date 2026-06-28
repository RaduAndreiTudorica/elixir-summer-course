defmodule School.Player do
  @type t :: %__MODULE__{
          name: String.t(),
          score: integer(),
          pid: pid(),
          ready?: boolean(),
          contraband_score: integer(),
          missed_contraband: integer()
        }

  defstruct name: nil,
            score: 0,
            pid: nil,
            ready?: false,
            contraband_score: 0,
            missed_contraband: 0
end
