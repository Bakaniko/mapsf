#' Plot a legend for a typology map
#' @description This function plots a legend for a typology map.
#'
#' @param pal a set of colors
#' @param col_na color for missing values
#' @param pos position of the legend, one of "topleft", "top",
#' "topright", "right", "bottomright", "bottom", "bottomleft",
#' "left" or a vector of two coordinates in map units
#' (c(x, y)).
#' @param val vector of categories.
#' @param title title of the legend
#' @param title_cex size of the legend title
#' @param val_cex size of the values in the legend
#' @param no_data if TRUE a "missing value" box is plotted
#' @param no_data_txt label for missing values.
#' @param frame whether to add a frame to the legend (TRUE) or not (FALSE)
#' @param border color of the boxes' borders
#' @param cex size of the legend; 2 means two times bigger
#' @param bg background of the legend
#' @param fg foreground of the legend
#' @keywords internal
#' @export
#' @import graphics
#' @return No return value, a legend is displayed.
#' @examples
#' plot.new()
#' plot.window(xlim = c(0, 1), ylim = c(0, 1), asp = 1)
#' mf_legend_t(val = c("type A", "type B"), pal = c("navy", "tomato"))
mf_legend_t <- function(pos = "topright",
                        val,
                        pal,
                        title = "Legend Title",
                        title_cex = .8,
                        val_cex = .6,
                        col_na = "white",
                        no_data = FALSE,
                        no_data_txt = "No Data",
                        frame = FALSE,
                        border,
                        bg,
                        fg,
                        cex = 1) {
  op <- par(mar = .gmapsf$args$mar, no.readonly = TRUE)
  on.exit(par(op))
  # stop if the position is not valid
  positions <- c(
    "bottomleft", "left", "topleft", "top", "bottom",
    "bottomright", "right", "topright",
    "bottomleft1", "bottomright1", "bottom1",
    "bottomleft2", "bottomright2", "bottom2",
    "topright1", "topleft1", "top1",
    "topright2", "topleft2", "top2"
  )
  if (length(pos) == 1) {
    if (!pos %in% positions) {
      return(invisible())
    }
  }

  # default values
  insetf <- strwidth("MM", units = "user", cex = 1)
  inset <- insetf * cex
  if (missing(bg)) bg <- .gmapsf$args$bg
  if (missing(fg)) fg <- .gmapsf$args$fg
  if (missing(border)) border <- fg


  w <- inset
  h <- inset / 1.5
  n <- length(val)
  # pal <- get_the_pal(pal, n)
  xy_leg <- NULL

  while (TRUE) {
    if (length(pos) == 2 & is.numeric(pos)) {
      xy_leg <- pos
    }
    xy_title <- get_xy_title(
      x = xy_leg[1],
      y = xy_leg[2],
      title = title,
      title_cex = title_cex
    )
    xy_box <- get_xy_box_t(
      x = xy_title$x,
      y = xy_title$y - inset / 2,
      n = n,
      w = w,
      h = h,
      inset = inset / 2
    )
    xy_nabox <- get_xy_nabox(
      x = xy_title$x,
      y = xy_box$ybottom[n] - inset / 2,
      w = w,
      h = h
    )
    xy_box_lab <- get_xy_box_lab_t(
      x = xy_box$xright[n] + inset / 4,
      y = xy_box$ytop[1],
      h = h,
      val = val,
      val_cex = val_cex,
      inset = inset / 2
    )
    xy_nabox_lab <- get_xy_nabox_lab(
      x = xy_nabox$xright + inset / 4,
      y = xy_nabox$ytop,
      h = h,
      no_data_txt = no_data_txt,
      val_cex = val_cex
    )
    xy_rect <- get_xy_rect(
      xy_title = xy_title,
      xy_box = xy_box,
      xy_nabox = xy_nabox,
      xy_box_lab = xy_box_lab,
      xy_nabox_lab = xy_nabox_lab,
      no_data = no_data,
      inset = inset,
      w = w,
      cho = FALSE
    )
    if (!is.null(xy_leg)) {
      break
    }
    xy_leg <- get_pos_leg(
      pos = pos,
      xy_rect = unlist(xy_rect),
      inset = inset,
      xy_title = xy_title,
      frame = frame
    )
  }

  if (frame) {
    rect(
      xleft = xy_rect[[1]] - insetf / 4,
      ybottom = xy_rect[[2]] - insetf / 4,
      xright = xy_rect[[3]] + insetf / 4,
      ytop = xy_rect[[4]] + insetf / 4,
      col = bg, border = fg, lwd = .7, xpd = TRUE
    )
  }
  text(xy_title$x,
    y = xy_title$y, labels = title, cex = title_cex,
    adj = c(0, 0), col = fg
  )
  rect(xy_box[[1]], xy_box[[2]], xy_box[[3]], xy_box[[4]],
    col = pal,
    border = fg, lwd = .7
  )
  text(xy_box_lab$x,
    y = xy_box_lab$y, labels = val, cex = val_cex,
    adj = c(0, 0.5), col = fg
  )
  if (no_data) {
    rect(xy_nabox[[1]], xy_nabox[[2]], xy_nabox[[3]], xy_nabox[[4]],
      col = col_na, border = fg, lwd = .7
    )
    text(xy_nabox_lab$x,
      y = xy_nabox_lab$y, labels = no_data_txt,
      cex = val_cex, adj = c(0, 0.5), col = fg
    )
  }


  return(invisible(NULL))
}
