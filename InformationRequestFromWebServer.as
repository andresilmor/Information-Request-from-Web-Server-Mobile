package {
	import flash.display.MovieClip;



	public class InformationRequestFromWebServer extends MovieClip {

		//Dependências
		import flash.text.TextField;
		import flash.events.FocusEvent;
		import flash.events.TransformGestureEvent;
		import flash.display.SimpleButton;
		import flash.events.TouchEvent;
		import flash.ui.Multitouch;
		import flash.ui.MultitouchInputMode;
		import flash.events.Event;
		import flash.net.*;
		import flash.display.DisplayObject;
		import flash.events.EventDispatcher;
		import flash.display.LoaderInfo;
		import flash.display.Loader;

		//Propriedades
		var swipeYsensibility: Number = 25;

		var XML_URL: String = "https://damdefesaer.000webhostapp.com/works.xml";
		var worksList: XMLList;
		var placeholder: MovieClip;
		var slideIndex: int = 0;

		var loader: URLLoader;
	

		//Construtor
		public function InformationRequestFromWebServer() {
			Multitouch.inputMode = MultitouchInputMode.GESTURE;

			stop();

			addSwipeEvent();

			prepareTextField();

			startXML();

		}

		public function prepareTextField(): void {
			workPage_mc.name_txt.multiline = true;
			workPage_mc.name_txt.wordWrap = true;

			workPage_mc.email_txt.multiline = true;
			workPage_mc.email_txt.wordWrap = true;

			workPage_mc.title_txt.multiline = true;
			workPage_mc.title_txt.wordWrap = true;

			workPage_mc.description_txt.multiline = true;
			workPage_mc.description_txt.wordWrap = true;

		}

		public function addSwipeEvent(): void {
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, swipe);

		}

		private function swipe(event: TransformGestureEvent): void {
			if (event.offsetX === -1) {
				if (slideIndex + 1 >= worksList.length()) {
					slideIndex = 0;
					updateSlide(slideIndex);

				} else {
					updateSlide(++slideIndex);

				}

			} else if (event.offsetX === 1) {
				if (slideIndex - 1 < 0) {
					slideIndex = worksList.length() - 1;
					updateSlide(slideIndex);

				} else {
					updateSlide(--slideIndex);

				}

			}

			if (event.offsetY === -1) {
				workPage_mc.y += swipeYsensibility;
				if (workPage_mc.y > 328.75) {
					workPage_mc.y = 328.75;

				}

			} else if (event.offsetY === 1) {
				workPage_mc.y -= swipeYsensibility;
				if (workPage_mc.y < 279.6) {
					workPage_mc.y = 279.6;

				}

			}

			if (event.offsetY === 0 && event.offsetX === 0) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
			}

		}

		private function startXML(): void {
			loader = new URLLoader(new URLRequest(XML_URL));
			loader.addEventListener(Event.COMPLETE, completeXMLLoader);

		}

		private function completeXMLLoader(e: Event): void {
			var xml: XML = new XML(e.target.data);
			worksList = xml.work;

			loader.removeEventListener(Event.COMPLETE, completeXMLLoader);
			updateSlide(slideIndex);

		}

		private function updateSlide(index: Number): void {
			workPage_mc.name_txt.text = worksList[index].@name;
			workPage_mc.email_txt.text = worksList[index].@email;
			workPage_mc.title_txt.text = worksList[index].@title;
			workPage_mc.description_txt.text = worksList[index].@description;
			loadImage(worksList[index].@photoURL, "photoPlaceholder");
			loadImage(worksList[index].@imageURL, "workImagePlaceholder");

		}



		private function loadImage(location: String, placeholderName: String) {
			removeLoadedImage(placeholderName);
			var imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplte);
			imageLoader.name = placeholderName;
			workPage_mc.addChild(imageLoader);
			imageLoader.load(new URLRequest("https://damdefesaer.000webhostapp.com/" + location));

		}

		private function onComplte(event: Event): void {
			EventDispatcher(event.target).removeEventListener(event.type, arguments.callee);
			var image: DisplayObject = (event.target as LoaderInfo).content;
			image.x = workPage_mc.getChildByName(image.parent.name + "_mc").x;
			image.y = workPage_mc.getChildByName(image.parent.name + "_mc").y;
			image.width = workPage_mc.getChildByName(image.parent.name + "_mc").width;
			image.height = workPage_mc.getChildByName(image.parent.name + "_mc").height;

		}

		private function removeLoadedImage(imageName: String): void {
			if (workPage_mc.getChildByName(imageName) != null && workPage_mc.contains(workPage_mc.getChildByName(imageName))) {
				workPage_mc.removeChild(workPage_mc.getChildByName(imageName));

			}

		}
		



	} //Fim de InformationRequestFromWebServer

}