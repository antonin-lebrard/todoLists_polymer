
import 'dart:html';

/// Draw a text box pointing to a [HtmlElement] in the page
///
/// It use the [HtmlElement.getBoundingClientRect] to get the position of [toAttach].
/// And it draw a Box near it with the [text] given in the constructor. 
/// A pointing part of the box point to [toAttach] given in the constructor.
/// Depending on what is the position of [toAttach] in the window, the box and the pointing part is draw 
/// at the left, at the right, upside or downside [toAttach].
class DialogueBox{
  CanvasElement canvas;
  
  String text;
  HtmlElement toAttach;
  
  bool isToDrawAtRight = false;
  bool isToDrawAtLeft = false;
  bool isToDrawUpside = false;
  bool isToDrawDownside = false;

  num yToPoint;
  num xToPoint;
  
  num xRect;
  num yRect;
  
  num yDeltaWithText;
  
  DialogueBox(this.text, this.toAttach, this.canvas, {String overridePlacement:null}){
    var rect = toAttach.getBoundingClientRect();
    xToPoint = ((rect.right - rect.left)/2) + rect.left;
    yToPoint = ((rect.bottom - rect.top)/2) + rect.top;

    if (overridePlacement != null){
      switch (overridePlacement){
        case "right":
          isToDrawAtRight = true;
          break;
        case "left":
          isToDrawAtLeft = true;
          break;
        case "down":
          isToDrawDownside = true;
          break;
        case "up":
          isToDrawUpside = true;
          break;
      }
    }
    if (!isToDrawAtLeft && !isToDrawAtRight && !isToDrawDownside && ! isToDrawUpside){
      if (xToPoint < window.innerWidth / 2) {
        if (yToPoint < window.innerHeight / 2)
          xToPoint < yToPoint ? isToDrawAtRight = true : isToDrawDownside = true;
        else
          xToPoint < window.innerHeight - yToPoint ? isToDrawAtRight = true : isToDrawUpside = true;
      } else {
        if (yToPoint < window.innerHeight / 2)
          window.innerWidth - xToPoint < yToPoint ? isToDrawAtLeft = true : isToDrawDownside = true;
        else
          window.innerWidth - xToPoint < window.innerHeight - yToPoint ? isToDrawAtLeft = true : isToDrawUpside = true;
      }
    }

    yDeltaWithText = topToBottomDeltaYWithText(this.canvas.getContext('2d'));
    
    if (isToDrawAtRight){
      xRect = xToPoint + 90;
      if (xRect + 320 > window.innerWidth)
        xRect = window.innerWidth - 320;
      yRect = yToPoint - 90;
      if (yRect < 0)
        yRect = 0;
      if (yRect + yDeltaWithText > window.innerHeight)
        yRect = window.innerHeight - yDeltaWithText;
    } else if (isToDrawAtLeft){
      xRect = xToPoint - 90 - 320;
      if (xRect < 0)
        xRect = 0;
      yRect = yToPoint - 90;
      if (yRect < 0)
        yRect = 0;
      if (yRect + yDeltaWithText > window.innerHeight)
        yRect = window.innerHeight - yDeltaWithText;
    } else if (isToDrawDownside){
      xRect = xToPoint - 170;
      if (xRect < 0)
        xRect = 0;
      if (xRect + 320 > window.innerWidth)
        xRect = window.innerWidth - 320;
      yRect = yToPoint + 90;
      if (yRect + yDeltaWithText > window.innerHeight)
        yRect = window.innerHeight - yDeltaWithText;
    } else if (isToDrawUpside){
      xRect = xToPoint - 170;
      if (xRect < 0)
        xRect = 0;
      if (xRect + 320 > window.innerWidth)
        xRect = window.innerWidth - 320;
      yRect = yToPoint - 90 - yDeltaWithText;
      if (yRect < 0)
        yRect = 0;
    }
  }
  
  void draw([_]){
    var context = canvas.context2D;
    context..lineWidth = 1.0
           ..fillStyle = "rgba(227, 225, 89, 1.0)"
           ..strokeStyle = "#000";
  
    if (isToDrawAtRight) {
      context..fillStyle = "rgba(227, 225, 89, 1.0)"
             ..beginPath()
             ..moveTo(xRect, yRect)
             ..lineTo(xRect + 320, yRect)
             ..lineTo(xRect + 320, yRect + yDeltaWithText)
             ..lineTo(xRect, yRect + yDeltaWithText)
             ..lineTo(xRect, (yRect + yDeltaWithText) - (((yRect + yDeltaWithText) - yRect)/2) + 15)
             ..lineTo(xToPoint, yToPoint)
             ..lineTo(xRect, (yRect + yDeltaWithText) - (((yRect + yDeltaWithText) - yRect)/2))
             ..lineTo(xRect, yRect)
             ..fill()
             ..closePath()
             ..stroke();
    } else if (isToDrawAtLeft) {
      context..fillStyle = "rgba(227, 225, 89, 1.0)"
             ..beginPath()
             ..moveTo(xRect, yRect)
             ..lineTo(xRect + 320, yRect)
             ..lineTo(xRect + 320, (yRect + yDeltaWithText) - (((yRect + yDeltaWithText) - yRect)/2))
             ..lineTo(xToPoint, yToPoint)
             ..lineTo(xRect + 320, (yRect + yDeltaWithText) - (((yRect + yDeltaWithText) - yRect)/2) + 15)
             ..lineTo(xRect + 320, yRect + yDeltaWithText)
             ..lineTo(xRect, yRect + yDeltaWithText)
             ..lineTo(xRect, yRect)
             ..fill()
             ..closePath()
             ..stroke();
    } else if (isToDrawDownside) {
      context..fillStyle = "rgba(227, 225, 89, 1.0)"
             ..beginPath()
             ..moveTo(xRect, yRect)
             ..lineTo(((xRect + 320)-xRect)/2 + xRect, yRect)
             ..lineTo(xToPoint, yToPoint)
             ..lineTo(((xRect + 320)-xRect)/2 + xRect + 30, yRect)
             ..lineTo(xRect + 320, yRect)
             ..lineTo(xRect + 320, yRect + yDeltaWithText)
             ..lineTo(xRect, yRect + yDeltaWithText)
             ..lineTo(xRect, yRect)
             ..fill()
             ..closePath()
             ..stroke();
    } else if (isToDrawUpside) {
      context..fillStyle = "rgba(227, 225, 89, 1.0)"
             ..beginPath()
             ..moveTo(xRect, yRect)
             ..lineTo(xRect + 320, yRect)
             ..lineTo(xRect + 320, yRect + yDeltaWithText)
             ..lineTo(((xRect + 320)-xRect)/2 + xRect +30, yRect + yDeltaWithText)
             ..lineTo(xToPoint, yToPoint)
             ..lineTo(((xRect + 320)-xRect)/2 + xRect, yRect + yDeltaWithText)
             ..lineTo(xRect, yRect + yDeltaWithText)
             ..lineTo(xRect, yRect)
             ..fill()
             ..closePath()
             ..stroke();
    }
    print("Je suis passé par la");
    wrapText(context);
  }
  
  void wrapText(CanvasRenderingContext2D context) {
    List<String> words = text.split(' ');
    String line = '';
    context.fillStyle = "rgba(0,0,0,1.0)";
    context.font = "14pt Calibri";
    num maxWidth = 300;
    num lineHeight = 24;
    num y = yRect + 20;
    for(int n = 0; n < words.length; n++) {
      String testLine = line + words[n] + ' ';
      TextMetrics metrics = context.measureText(testLine);
      num testWidth = metrics.width;
      if (testWidth > maxWidth && n > 0) {
        context.fillText(line, xRect + 20, y);
        line = words[n] + ' ';
        y += lineHeight;
      }
      else {
        line = testLine;
      }
    }
    context.fillText(line, xRect + 20, y);
  }
  
  num topToBottomDeltaYWithText(CanvasRenderingContext2D context){
    List<String> words = text.split(' ');
    String line = '';
    context.fillStyle = "rgba(0,0,0,1.0)";
    context.font = "14pt Calibri";
    num maxWidth = 300;
    num lineHeight = 24;
    num y = 20;
    for(int n = 0; n < words.length; n++) {
      String testLine = line + words[n] + ' ';
      TextMetrics metrics = context.measureText(testLine);
      num testWidth = metrics.width;
      if (testWidth > maxWidth && n > 0) {
        line = words[n] + ' ';
        y += lineHeight;
      }
      else {
        line = testLine;
      }
    }
    return y + 14;
  }
}