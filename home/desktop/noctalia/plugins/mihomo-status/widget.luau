-- Mirrors the two switches bound to CTRL+Mod+T / CTRL+Mod+P in
-- home/desktop/mihomo-keys.nix. The mihomo REST API is the source of truth, so
-- the widget reports what the core is actually doing instead of what was last
-- toggled - including "not running", which those scripts only surface through
-- a transient notification.
--
-- The bar is docked left and only 36px thick, so the label is sized to fit the
-- capsule and the layout follows the bar's axis: a column on a side bar, a row
-- on a horizontal one.
local API = "http://127.0.0.1:9091/configs"

noctalia.setUpdateInterval(3000)

local running = false
local tun = false
local mode = nil

local function describe()
  if not running then
    return "shield-off", "--", "on_surface_variant"
  end

  local label = "?"
  if mode == "rule" then
    label = "RULE"
  elseif mode == "direct" then
    label = "DIRECT"
  elseif mode then
    label = mode:upper()
  end

  local glyph = tun and "shield-check" or "shield-off"
  local color = tun and "primary" or "on_surface_variant"
  return glyph, label, color
end

local function paint()
  local glyph, label, color = describe()

  local vertical = barWidget.isVertical()
  local container = vertical and ui.column or ui.row

  local label_props = { text = label, color = color }
  if vertical then
    label_props.fontSize = 8
  end

  barWidget.render(container({ gap = 2, align = "center" }, {
    ui.glyph({ name = glyph, size = 14, color = color }),
    ui.label(label_props),
  }))

  if running then
    barWidget.setTooltip("TUN " .. (tun and "on" or "off") .. "  ·  routing " .. label)
  else
    barWidget.setTooltip("mihomo is not running")
  end
end

local function refresh()
  local started = noctalia.http({ url = API }, function(res)
    if not res.ok or res.status ~= 200 then
      running, tun, mode = false, false, nil
      paint()
      return
    end

    local cfg = noctalia.json.decode(res.body)
    if type(cfg) ~= "table" then
      running, tun, mode = false, false, nil
      paint()
      return
    end

    running = true
    tun = type(cfg.tun) == "table" and cfg.tun.enable == true
    mode = type(cfg.mode) == "string" and cfg.mode:lower() or nil
    paint()
  end)

  if not started then
    running, tun, mode = false, false, nil
    paint()
  end
end

local function toggle(command)
  noctalia.runAsync({ command }, function()
    -- runAsync reports back once the helper has exited, and the helper only
    -- exits after its PATCH landed, so this reads the new state.
    refresh()
  end)
end

function update()
  refresh()
end

function onClick()
  toggle("mihomo-tun-toggle")
end

function onRightClick()
  toggle("mihomo-proxy-toggle")
end