defmodule SchoolWeb.GameComponents do
  use Phoenix.Component

  attr :player_name, :string, required: true
  attr :score, :integer, required: true
  attr :contraband_score, :integer, default: 0

  def score_banner(assigns) do
    ~H"""
    <div class="player-score-bar">
      <div class="player-identity">
        <div class="player-avatar">MK</div>
        <div>
          <div class="player-name">Inspector {@player_name}</div>
          <div class="player-role">Senior Postal Officer</div>
        </div>
      </div>
      <div class="score-group">
        <div class="score-display">
          <span class="score-label">Score</span>
          <span class="score-value">{@score}</span>
          <span class="score-unit">pts</span>
        </div>
        <div class="score-display score-display-contraband">
          <span class="score-label">Contraband</span>
          <span class="score-value">{@contraband_score}</span>
          <span class="score-unit">pts</span>
        </div>
      </div>
    </div>
    """
  end

  def match_time_remaining(assigns) do
    ~H"""
    <div class="card-timer-section">
      <span class="card-timer-label">Match time remaining</span>
      <div class="card-timer-track">
        <div class="card-timer-fill" style="width: 0%;"></div>
      </div>
      <span class="card-timer-seconds">0s</span>
    </div>
    """
  end

  attr :package, :map, required: true
  attr :timestamp, :integer, required: true
  attr :validation_result, :atom, required: true

  def package_inspection_form(assigns) do
    ~H"""
    <div class="card-reveal-wrapper">
      <%= case @validation_result do %>
        <% :correct -> %>
          <div class="stamp-result" id={"card-#{@timestamp}"}>
            <div class="stamp-mark approved">
              <span class="stamp-label">Approved</span>
              <span class="stamp-points">+1</span>
            </div>
          </div>
        <% :incorrect -> %>
          <div class="stamp-result" id={"card-#{@timestamp}"}>
            <div class="stamp-mark rejected">
              <span class="stamp-label">Rejected</span>
              <span class="stamp-points">−1</span>
            </div>
          </div>
        <% :caught -> %>
          <div class="stamp-result" id={"card-#{@timestamp}"}>
            <div class="stamp-mark caught">
              <span class="stamp-label">Contraband Seized</span>
              <span class="stamp-points">+2</span>
            </div>
          </div>
        <% :false_positive -> %>
          <div class="stamp-result" id={"card-#{@timestamp}"}>
            <div class="stamp-mark false-positive">
              <span class="stamp-label">False Report</span>
              <span class="stamp-points">−2</span>
            </div>
          </div>
        <% nil -> %>
          <div></div>
      <% end %>

      <div class="package-card">
        <div class="card-header">
          <div class="card-title-group">
            <div class="card-title">Package Inspection Form</div>
            <div class="card-id">PKG-{@timestamp}</div>
          </div>
          <div class="card-stamp">
            <span class="card-stamp-text">Postage</span>
            <span class="card-stamp-value">€4.50</span>
            <span class="card-stamp-text">Paid</span>
          </div>
        </div>

        <div class="package-fields">
          <div class="field">
            <div class="field-label">Package Type</div>
            <div class="field-value type-badge">{capitalise(@package.type)}</div>
          </div>
          <div class="field">
            <div class="field-label">Weight</div>
            <div class="field-value">{@package.weight}g</div>
          </div>
          <div class="field">
            <div class="field-label">Destination</div>
            <div class="field-value">{capitalise(@package.destination)}</div>
          </div>
          <div class="field">
            <div class="field-label">Shipping Class</div>
            <div class="field-value">{capitalise(@package.shipping_class)}</div>
          </div>
          <div class="field">
            <div class="field-label">Declared Value</div>
            <div class="field-value">{@package.declared_value}</div>
          </div>
          <div class="field">
            <div class="field-label">Origin Country</div>
            <div class="field-value">{@package.origin_country}</div>
          </div>
          <div class="field">
            <div class="field-label">Condition</div>
            <div class="field-value">
              <span class={"badge badge-condition badge-condition-#{@package.condition}"}>
                {capitalise(@package.condition)}
              </span>
            </div>
          </div>
        </div>

        <div class="package-checks">
          <span :if={@package.has_customs_form} class="check-tag has">
            <span class="check-dot"></span> Customs Form
          </span>
          <span :if={@package.has_insurance} class="check-tag has">
            <span class="check-dot"></span> Insurance
          </span>
          <span :if={@package.has_fragile_sticker} class="check-tag has">
            <span class="check-dot"></span> Fragile Sticker
          </span>
        </div>

        <div class="card-actions">
          <button phx-click="decline" class="btn btn-decline">
            <span class="btn-icon">✕</span> Decline
          </button>
          <button phx-click="approve" class="btn btn-approve">
            <span class="btn-icon">✓</span> Approve
          </button>
        </div>

        <div class="card-actions-secondary">
          <button phx-click="report_police" class="btn btn-report-police">
            <span class="btn-icon">🚨</span> Report to Police
          </button>
        </div>
      </div>
    </div>
    """
  end

  attr :local_player, :map, default: nil

  def ready_section(assigns) do
    ~H"""
    <div class="ready-section">
      <span class="ready-title">Report for Duty</span>

      <%= if @local_player do %>
        <.form for={%{}} phx-submit="ready">
          <div class="ready-input-group">
            <label class="player-name" for="inspector-name">{@local_player.name}</label>
          </div>

          <%= if @local_player.ready? do %>
            ✓ Ready
          <% else %>
            <button class="btn">
              Ready
            </button>
          <% end %>
        </.form>
      <% else %>
        <.form for={%{}} phx-submit="join">
          <div class="ready-input-group">
            <label class="ready-label" for="inspector-name">Inspector Name</label>
            <input
              class="ready-input"
              type="text"
              id="inspector-name"
              name="name"
              placeholder="e.g. Inspector Wazowski"
              value=""
              autocomplete="off"
            />
          </div>

          <button class="btn-ready">
            Join
          </button>
        </.form>
      <% end %>
    </div>
    """
  end

  attr :rule_descriptions, :list, required: true

  def postal_regulations(assigns) do
    ~H"""
    <div class="rules-reference">
      <div class="rules-header">
        <span class="rules-title">Postal Regulations</span>
      </div>

      <%= for {desc, index} <- Enum.with_index(@rule_descriptions) do %>
        <div class="rules-list">
          <div class="rule-item">
            <span class="rule-number">{index + 1}</span><span>{desc}</span>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  @unwritten_hints [
    "Packages from countries with a known smuggling history deserve extra scrutiny — they aren't automatically guilty, but verify everything else twice.",
    "Heavy damage or deterioration can mean rough handling, or it can mean someone forced the package open and resealed it.",
    "A customs form that's present isn't necessarily a customs form that's real — forged stamps and mismatched formats happen.",
    "None of these are rules you can cite. They're judgment calls. Trust the regulations first, your gut second."
  ]

  def unwritten_hints(assigns) do
    assigns = assign(assigns, :hints, @unwritten_hints)

    ~H"""
    <details class="hints-reference">
      <summary class="hints-header">
        <span class="hints-title">⚠ Field Notes (Unofficial)</span>
      </summary>

      <div class="hints-list">
        <div :for={{hint, index} <- Enum.with_index(@hints)} class="hint-item">
          <span class="hint-number">{index + 1}</span><span>{hint}</span>
        </div>
      </div>
    </details>
    """
  end

  attr :player_list, :list, required: true

  def leaderboard(assigns) do
    ~H"""
    <div class="leaderboard">
      <div class="leaderboard-header">
        <div class="leaderboard-title">Inspector Rankings</div>
      </div>

      <ul class="leaderboard-list">
        <li :for={player <- @player_list} class="leaderboard-item">
          <span class="rank rank-1">1</span>
          <div class="lb-player-info">
            <div class="lb-player-name">{player.name}</div>
          </div>
          <div class="lb-player-score">{player.score}</div>
          <div class="lb-player-score lb-player-score-contraband">
            🚨 {Map.get(player, :contraband_score, 0)}
          </div>
        </li>
      </ul>
    </div>
    """
  end

  attr :player_list, :list, required: true

  def match_end_overlay(assigns) do
    ~H"""
    <div class="match-end-overlay" style="display:flex">
      <div class="match-end-card">
        <div class="match-end-label">Match Complete</div>
        <div class="match-end-title">Final Results</div>
        <ul class="match-end-scores">
          <li :for={{player, index} <- Enum.with_index(@player_list)}>
            <span>{get_medal(index)} {player.name}</span>
            <span class="final-score">
              {final_score(player)} pts
              <span class="final-score-breakdown">
                ({player.score} insp. {format_signed(Map.get(player, :contraband_score, 0))} contr.{missed_contraband_note(
                  player
                )})
              </span>
            </span>
          </li>
        </ul>
        <button class="btn-new-match">New Match</button>
      </div>
    </div>
    """
  end

  defp final_score(player) do
    player.score + Map.get(player, :contraband_score, 0) - Map.get(player, :missed_contraband, 0)
  end

  defp format_signed(n) when n >= 0, do: "+#{n}"
  defp format_signed(n), do: "#{n}"

  defp missed_contraband_note(player) do
    case Map.get(player, :missed_contraband, 0) do
      0 -> ""
      missed -> " −#{missed} missed"
    end
  end

  def capitalise(term) do
    String.capitalize("#{term}")
  end

  def get_medal(place) do
    Enum.at(["🥇", "🥈", "🥉"], place)
  end
end
