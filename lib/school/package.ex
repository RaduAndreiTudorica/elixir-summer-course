defmodule School.Package do
  @type t :: %__MODULE__{
          type: :letter | :parcel | :fragile,
          weight: pos_integer(),
          destination: :domestic | :eu | :international,
          shipping_class: :standard | :express | :priority,
          declared_value: float(),
          has_customs_form: boolean(),
          has_insurance: boolean(),
          has_fragile_sticker: boolean(),
          origin_country: string(),
          condition: :pristine | :worn | :damaged | :severely_damage,
          contraband_type: :none | :drugs | :weapons | :organs,
          customs_form_forged: boolean()
        }

  defstruct type: :letter,
            weight: 100,
            destination: :domestic,
            shipping_class: :standard,
            declared_value: 100,
            has_customs_form: true,
            has_insurance: true,
            has_fragile_sticker: true,
            origin_country: "Romania",
            condition: :pristine,
            contraband_type: :none,
            customs_form_forged: false

  def contains_contraband?(package) do
    case package.contaband_type do
      :none -> false
      _ -> true
    end
  end
end
