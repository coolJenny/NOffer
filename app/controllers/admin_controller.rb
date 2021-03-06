class AdminController < ShopifyApp::AuthenticatedController
  skip_before_filter :verify_authenticity_token
  before_action      :set_option, only: [:index, :generate_script]

  def index
    @products   = ShopifyAPI::Product.all
    @all_orders = ShopifyAPI::Order.all     
    
    saved_orders = Order.pluck(:ordername)
    @orders = saved_orders.collect {|order_name| ShopifyAPI::Order.where(:name => order_name).first }
    
    @dashboard = { 
                    today_count: 0, today_price: 0, 
                    yesterday_count: 0, yesterday_price: 0, 
                    week_count: 0, week_price: 0, 
                    month_count: 0, month_price: 0,
                    year_count: 0, year_price: 0,
                    all_count: 0, all_price: 0,
                    today_tcount: 0, week_tcount: 0,
                    month_tcount: 0, year_tcount: 0
                  }
    @all_orders.each{|order|
        if Date.parse(order.created_at) == Date.today
            @dashboard[:today_tcount] += 1
        end

        if Date.parse(order.created_at) > ( Date.today - 7 )
            @dashboard[:week_tcount] += 1
        end

        if Date.parse(order.created_at) > Date.today.prev_month
            @dashboard[:month_tcount] += 1
        end

        if Date.parse(order.created_at) > Date.today.prev_year
            @dashboard[:year_tcount] += 1
        end
    }

    @orders.each {|order|

        if Date.parse(order.created_at) == Date.today
            @dashboard[:today_count] += 1
            @dashboard[:today_price] += order.total_price.to_f 
        end

        if Date.parse(order.created_at) == Date.today.prev_day
            @dashboard[:yesterday_count] += 1
            @dashboard[:yesterday_price] += order.total_price.to_f
        end

        if Date.parse(order.created_at) > ( Date.today - 7 )
            @dashboard[:week_count] += 1
            @dashboard[:week_price] += order.total_price.to_f
        end

        if Date.parse(order.created_at) > Date.today.prev_month
            @dashboard[:month_count] += 1
            @dashboard[:month_price] += order.total_price.to_f
        end

        if Date.parse(order.created_at) > Date.today.prev_year
            @dashboard[:year_count] += 1
            @dashboard[:year_price] += order.total_price.to_f
        end

        @dashboard[:all_count] += 1
        @dashboard[:all_price] += order.total_price.to_f

    }


    @metafield  = ShopifyAPI::Metafield.find(:all, :params => {:resource => "orders" })
    # meta_field  = ShopifyAPI::Metafield.new({
    #                                            :description => 'Profit Pal',
    #                                            :namespace   => 'profit_pal',
    #                                            :key         => 'tomsalinger',
    #                                            :value       => 12137891,
    #                                            :value_type  => 'integer'
    #                                        })
    # @order.add_metafield(meta_field)    
  end



  def generate_script
    
    option      = params[:option]
    background  = ActionController::Base.helpers.asset_path('background.png')
    background1 = ActionController::Base.helpers.asset_path('background1.png')

    theme       = ShopifyAPI::Theme.where(:role => 'main').first
  
    case option

      when 'option1'

        styleContent = "@import url('https://fonts.googleapis.com/css?family=Open+Sans');
                        @import url('https://fonts.googleapis.com/css?family=Roboto');
                        @import url('https://fonts.googleapis.com/css?family=Lato');
                        @import url('https://fonts.googleapis.com/css?family=Josefin+Sans');
                        @import url('https://fonts.googleapis.com/css?family=Lobster');
                        @import url('https://fonts.googleapis.com/css?family=Dancing+Script');
                        @import url('https://fonts.googleapis.com/css?family=Playfair+Display');
                        @import url('https://fonts.googleapis.com/css?family=Chewy');
                        @import url('https://fonts.googleapis.com/css?family=Quicksand');
                        @import url('https://fonts.googleapis.com/css?family=Satisfy');
                        @import url('https://fonts.googleapis.com/css?family=Oswald');
                        @import url('https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css');

                        /* Offer setting tab */
                        #tsmodal-fade{position: fixed; top: 0; width: 100%;  height: 100%; z-index: 1000; background: rgba(0,0,0,.5); left: 0;}
                        div#close{ position: absolute; right: calc(50vw - 295px); margin-top: -12px;  background: #{params[:txt_color]};  display: inline-block;  border-radius: 50%;  padding: 2px 7px;  color: #fff;  border: 3px solid #fff;  box-shadow: 0 0 3px grey;  cursor: pointer; transition: all 1s;}
                        div#close:hover{ transform: rotate(360deg)scale(1.3); }

                         div.preview-dialog{
                            text-align: center;
                            margin: auto;
                            margin-top: 10%;
                            border: 5px double #{params[:bd_color]};
                            width: 555px;
                            height: 350px;
                            box-shadow: 0 0 5px grey;
                            background: #{params[:bg_color]};
                         }
                         .main-content{
                            overflow: hidden;
                            width: 100%;
                            height: 100%;
                            position: relative;    
                         }
                         p.main-text{
                            padding: 10px;
                            color: #{params[:txt_color]};
                            font-size: #{params[:font_size]}px;
                            font-family: #{params[:main_font]};
                         }
                        .main-title{
                            color: #{params[:main_t_color]} !important;
                            font-size: #{params[:main_t_size]}px;
                            font-family: #{params[:main_t_font]};
                         }
                        .round-star-label {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: relative;
                          border: none;                          
                          text-align: center;
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          top: -70px;
                          left: 0;

                        }

                        .round-star-label::before {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: absolute;
                          content: '';
                          top: 0;
                          left: 0;
                          border: none;
                          color: rgba(0,0,0,1);
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          text-shadow: none;
                          -webkit-transform: rotateZ(30deg)   ;
                          transform: rotateZ(30deg)   ;
                        }

                        .round-star-label::after {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: absolute;
                          content: '';
                          top: 0;
                          left: 0;
                          border: none;
                          color: rgba(0,0,0,1);
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          text-shadow: none;
                          -webkit-transform: rotateZ(60deg);
                          transform: rotateZ(60deg);
                        }

                        /* Ribbon */
                        .ribbon {
                            position: relative;
                            width: 80%;
                            margin: 0;
                            z-index: 1000;
                            bottom: -48px;
                            right: -8px;
                        }

                        .ribbon:before,
                        .ribbon i:before {
                            content: '';
                            position: absolute;
                            bottom: -4px;
                            border: 12px solid #{params[:ribbon_color]};
                        }

                        .ribbon:before {
                            left: -26px;
                            border-left-color: transparent;
                            -webkit-transform: rotate(-16deg);
                               -moz-transform: rotate(-16deg);
                                -ms-transform: rotate(-16deg);
                                 -o-transform: rotate(-16deg);
                                    transform: rotate(-16deg);
                        }
                        .oldie .ribbon:before {
                            left: -48px;
                        }

                        .ribbon i:before {
                            right: -26px;
                            border-right-color: transparent;
                            -webkit-transform: rotate(16deg);
                               -moz-transform: rotate(16deg);
                                -ms-transform: rotate(16deg);
                                 -o-transform: rotate(16deg);
                                    transform: rotate(16deg);
                            z-index: -1;
                        }
                        .oldie .ribbon i:before {
                            right: -48px;
                        }

                        .ribbon i:after,
                        .ribbon u:after {
                            content: '';
                            position: absolute;
                            border-style: solid;
                            bottom: -4px;
                            z-index: 0;
                        }

                        .ribbon i:after {
                            right: -16px;
                            border-color: transparent transparent transparent #{params[:ribbon_color]};
                            border-width: 0 0 4px 16px;
                        }

                        .ribbon u:after {
                            left: 0;
                            border-color: transparent #{params[:ribbon_color]} transparent transparent;
                            border-width: 0 16px 4px 0;
                        }

                        .ribbon u {
                            display: block;
                            position: relative;
                            width: 100%;
                            left: -16px;
                            padding: 8px 12px 12px;
                            background: #{params[:ribbon_color]};
                            -webkit-border-top-left-radius: 50% 8px;
                                    border-top-left-radius: 50% 8px;
                            -webkit-border-top-right-radius: 50% 8px;
                                    border-top-right-radius: 50% 8px;
                            text-align: center;
                            text-decoration: none;
                            color: #{params[:rt_color]};
                            text-shadow: 0 1px 1px gray, 0 2px 1px gray;
                            font-size: #{params[:ribbon_size]}px;
                            font-family: #{params[:ribbon_font]};
                            font-style: normal;
                        }
                        .oldie .ribbon u {
                            padding: 0 16px;
                            *left: 0px;
                            *padding: 0;
                        }

                        .ribbon u {
                            left: 0;
                            margin: 0 -16px;
                            width: auto;
                        }

                        .ribbon u::selection { background-color: #{params[:ribbon_color]}; }
                        .ribbon u::-moz-selection { background-color: #{params[:ribbon_color]}; }

                        .ribbon u:before,
                        .ribbon:after {
                            content: '';
                            position: absolute;
                            height: 8px;
                            left: 0;
                            bottom: 0;
                            -webkit-border-top-left-radius: 50% 8px;
                                    border-top-left-radius: 50% 8px;
                            -webkit-border-top-right-radius: 50% 8px;
                                    border-top-right-radius: 50% 8px;
                            box-shadow: inset 0 2px 3px rgba(0, 0, 0, .3);
                        }
                        .oldie .ribbon u:before,
                        .oldie .ribbon:after {
                            content: none;
                        }

                        .ribbon u:before {
                            width: 100%;
                            background: #{params[:ribbon_color]};
                        }

                        .ribbon:after {
                            width: 100%;
                            background: #{params[:badge_color]};
                            z-index: 1;
                        }
                        .star-text{
                            position: absolute;
                            z-index: 1000;
                            text-align: center;
                            width: 100%;
                            display: block;
                            color: #{params[:bt_color]};
                            font-size: #{params[:badge_size]}px;
                            font-family: #{params[:badge_font]};
                            font-weight: 700;
                            padding: 5px 0;
                            text-shadow: 2px 2px 1px gray;
                        }

                        .arrow-right {
                          background-color: #{params[:corner_color]};
                          height: 400px;
                          left: -200px;
                          position: absolute;
                          bottom: -300px;
                          width: 400px;  
                          -webkit-transform: rotate(-50deg);
                                  transform: rotate(-50deg);
                        }

                         a#btn{
                            padding: 3px 15px;
                            border-radius: 3px;
                            box-shadow: 0 0 3px gray;
                            text-decoration: none;
                            font-size: #{params[:btn_size]}px;
                            background: #{params[:main_color]};
                            color: #{params[:btn_color]};
                            font-family: #{params[:btn_font]};
                            position: absolute;
                            bottom: 5px;
                            right: 100px;
                            transition: 1s all ease;
                         }
                         a#btn:hover{
                            transform: scale(1.2);
                         }

                        .use-code{
                            padding: 20px;
                            border-radius: 3px;
                            margin-right: 10px;
                            box-shadow: 0 0 3px #000;
                            font-size: 13px;
                         }
                        .use-code b{
                            font-size: 30px;
                         }

                        .pop-product-img{
                            transition: all 2s ease;
                         }

                        .pop-product-img:hover{
                            transform: #{params[:animation]};
                        }


                        .hms-div{
                          margin-left: 20px;
                          text-align: center;
                        }
                        .hms-div p{
                          color: #777;
                          font-size: 10px;
                        }
                        .hms-div div{
                          border-radius: 2px;
                          background: #fff;
                          color: #ff0000;
                          font-family: #{params[:timer_font]};
                          font-size: 25px;
                          width: 40px;
                          box-shadow: 0 0 5px gray;
                          padding: 5px 0 3px;
                          margin: -10px auto;
                        }
                        "
        jsContent    = "$(function() {
                          $('#tsmodal').addClass('animated bounceInDown');
                          $('#close').on('click', function(){
                              $('div#tsmodal-fade').addClass('animated slideOutDown');
                            });
                          var hms = '#{params[:time_left]}';   
                          var a = hms.split(':');
                          var seconds = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]);
                          var selectedSeconds = new Date().getTime() + seconds*1000;    
                          $('div.time-left').countdown(selectedSeconds, {elapse: true})
                          .on('update.countdown', function(event) {
                            var $this = $(this);
                            if (event.elapsed) {
                              $('div#tsmodal-fade').addClass('animated zoomOut');
                            } else {
                              $this.html(event.strftime('<table><tr><td> <div class=\"hms-div\"> <p>HOURS</p> <div>%H</div> </div> </td> <td> <div class=\"hms-div\"> <p>MINUTES</p> <div>%M</div> </div> </td> <td> <div class=\"hms-div\"> <p>SECONDS</p> <div>%S</div>   </div>  </td>   </tr> </table>'));
                            }
                          });
                          $('a#btn').on('click', function(){
                              var redirect_url = $(this).attr('data-link');
                              $.ajax({
                                  url: '#{save_order_url}',
                                  data: { ordername: $(this).attr('data-order'), shop: '#{@shop.shopify_domain}' },
                                  type: 'post',
                                  success: function(response){
                                        if(response.status == 'success'){
                                            window.top.location.href = redirect_url;
                                          }else{
                                            $('div#tsmodal-fade').addClass('animated slideOutDown');
                                          }
                                    }
                                });
                          });

                       });"

        result = "<link href='{{'tspopup.css' | asset_url}}' rel='stylesheet' type='text/css' media='all' />
                  <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
                  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.5.2/animate.min.css'>
                  <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>
                  <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery.countdown/2.2.0/jquery.countdown.min.js'></script>
                  <script src='{{'tspopup.js' | asset_url }}' type='text/javascript' ></script>
                  <div id='tsmodal-fade'>

                  <div id = 'tsmodal' class='preview-dialog' >
                   <div id='close'>X</div>
                   <div class='main-content'>
                    <div class='row'>
                      <div class='col-xs-6'>
                        <h2 class='main-title'>#{params[:product].split(':::')[2]}</h2>               
                        <p class='main-text' >
                          #{params[:main_text]}
                        </p>            
                      </div>
                      <div class='col-xs-6'>
                        <br>
                        <a href='https://#{ShopifyAPI::Shop.current.domain}/products/#{params[:product].split(':::')[1]}'>
                          <img src='#{params[:product].split(':::')[0]}' width='70%' class='pop-product-img' >
                        </a>          
                      </div>
                    </div>          
                    
                    <div style='position: relative; top: -10%; right: 0;' >
                      <div class='row' >
                        <div class='col-xs-2'></div>
                        <div class='col-xs-4'>
                          <p style='font-size: #{params[:timer_size]}px; color: #{params[:timer_color]}; font-family: #{params[:timer_font]}; margin-right: -40px; margin-top: 15px;'>
                            #{params[:timer_text]}</p>
                        </div>
                        <div class='col-xs-6 time-left' style='font-size: 40px;' >
                          <table>
                            <tr>
                              <td>
                                <div class='hms-div'>
                                  <p>HOURS</p>
                                  <div>00</div>
                                </div>
                              </td>
                              <td>
                                <div class='hms-div'>
                                  <p>MINUTES</p>
                                  <div>20</div>
                                </div>
                              </td>
                              <td>
                                <div class='hms-div'>
                                  <p>SECONDS</p>
                                  <div>00</div>
                                </div>
                              </td>
                            </tr>
                          </table>
                        </div>
                      </div>  
                    </div>

                    <a href='#{params[:btn_link]}' id='btn' data-order='{{order.name}}' >
                      #{params[:btn_txt]}
                    </a>  
                    
                    <div class='arrow-right' ></div>                
                  </div>

                  <div class='round-star-label' >
                    <span class='star-text'>#{params[:percentage]}#{params[:distype]}</span>
                    <h1 class=ribbon>
                      <i><u class='ribbon-text'>#{params[:ribbon_text]}</u></i>
                    </h1>
                  </div>
                </div>

              </div>"

      when 'option2'
        
        styleContent = "@import url('https://fonts.googleapis.com/css?family=Open+Sans');
                        @import url('https://fonts.googleapis.com/css?family=Roboto');
                        @import url('https://fonts.googleapis.com/css?family=Lato');
                        @import url('https://fonts.googleapis.com/css?family=Josefin+Sans');
                        @import url('https://fonts.googleapis.com/css?family=Lobster');
                        @import url('https://fonts.googleapis.com/css?family=Dancing+Script');
                        @import url('https://fonts.googleapis.com/css?family=Playfair+Display');
                        @import url('https://fonts.googleapis.com/css?family=Chewy');
                        @import url('https://fonts.googleapis.com/css?family=Quicksand');
                        @import url('https://fonts.googleapis.com/css?family=Satisfy');
                        @import url('https://fonts.googleapis.com/css?family=Oswald');
                        @import url('https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css');

                        /* Offer setting tab */
                        #tsmodal-fade{position: fixed; top: 0; width: 100%;  height: 100%; z-index: 1000; background: rgba(0,0,0,.5); left: 0;}
                        div#close{ position: absolute; right: calc(50vw - 295px); margin-top: -12px;  background: #{params[:txt_color]};  display: inline-block;  border-radius: 50%;  padding: 2px 7px;  color: #fff;  border: 3px solid #fff;  box-shadow: 0 0 3px grey;  cursor: pointer; transition: all 1s;}
                        div#close:hover{ transform: rotate(360deg)scale(1.3); }

                         div.preview-dialog{
                            text-align: center;
                            margin: auto;
                            margin-top: 10%;
                            border: 5px double #{params[:bd_color]};
                            width: 555px;
                            height: 350px;
                            box-shadow: 0 0 5px grey;
                            background: #{params[:bg_color]};
                         }
                         .main-content{
                            overflow: hidden;
                            width: 100%;
                            height: 100%;
                            position: relative;    
                         }
                         p.main-text{
                            padding: 10px;
                            color: #{params[:txt_color]};
                            font-size: #{params[:font_size]}px;
                            font-family: #{params[:main_font]};
                         }
                        .main-title{
                            color: #{params[:main_t_color]} !important;
                            font-size: #{params[:main_t_size]}px;
                            font-family: #{params[:main_t_font]};
                         }
                        .round-star-label {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: relative;
                          border: none;                          
                          text-align: center;
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          top: -70px;
                          left: 0;

                        }

                        .round-star-label::before {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: absolute;
                          content: '';
                          top: 0;
                          left: 0;
                          border: none;
                          color: rgba(0,0,0,1);
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          text-shadow: none;
                          -webkit-transform: rotateZ(30deg)   ;
                          transform: rotateZ(30deg)   ;
                        }

                        .round-star-label::after {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: absolute;
                          content: '';
                          top: 0;
                          left: 0;
                          border: none;
                          color: rgba(0,0,0,1);
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          text-shadow: none;
                          -webkit-transform: rotateZ(60deg);
                          transform: rotateZ(60deg);
                        }

                        /* Ribbon */
                        .ribbon {
                            position: relative;
                            width: 80%;
                            margin: 0;
                            z-index: 1000;
                            bottom: -48px;
                            right: -8px;
                        }

                        .ribbon:before,
                        .ribbon i:before {
                            content: '';
                            position: absolute;
                            bottom: -4px;
                            border: 12px solid #{params[:ribbon_color]};
                        }

                        .ribbon:before {
                            left: -26px;
                            border-left-color: transparent;
                            -webkit-transform: rotate(-16deg);
                               -moz-transform: rotate(-16deg);
                                -ms-transform: rotate(-16deg);
                                 -o-transform: rotate(-16deg);
                                    transform: rotate(-16deg);
                        }
                        .oldie .ribbon:before {
                            left: -48px;
                        }

                        .ribbon i:before {
                            right: -26px;
                            border-right-color: transparent;
                            -webkit-transform: rotate(16deg);
                               -moz-transform: rotate(16deg);
                                -ms-transform: rotate(16deg);
                                 -o-transform: rotate(16deg);
                                    transform: rotate(16deg);
                            z-index: -1;
                        }
                        .oldie .ribbon i:before {
                            right: -48px;
                        }

                        .ribbon i:after,
                        .ribbon u:after {
                            content: '';
                            position: absolute;
                            border-style: solid;
                            bottom: -4px;
                            z-index: 0;
                        }

                        .ribbon i:after {
                            right: -16px;
                            border-color: transparent transparent transparent #{params[:ribbon_color]};
                            border-width: 0 0 4px 16px;
                        }

                        .ribbon u:after {
                            left: 0;
                            border-color: transparent #{params[:ribbon_color]} transparent transparent;
                            border-width: 0 16px 4px 0;
                        }

                        .ribbon u {
                            display: block;
                            position: relative;
                            width: 100%;
                            left: -16px;
                            padding: 8px 12px 12px;
                            background: #{params[:ribbon_color]};
                            -webkit-border-top-left-radius: 50% 8px;
                                    border-top-left-radius: 50% 8px;
                            -webkit-border-top-right-radius: 50% 8px;
                                    border-top-right-radius: 50% 8px;
                            text-align: center;
                            text-decoration: none;
                            color: #{params[:rt_color]};
                            text-shadow: 0 1px 1px gray, 0 2px 1px gray;
                            font-size: #{params[:ribbon_size]}px;
                            font-family: #{params[:ribbon_font]};
                            font-style: normal;
                        }
                        .oldie .ribbon u {
                            padding: 0 16px;
                            *left: 0px;
                            *padding: 0;
                        }

                        .ribbon u {
                            left: 0;
                            margin: 0 -16px;
                            width: auto;
                        }

                        .ribbon u::selection { background-color: #{params[:ribbon_color]}; }
                        .ribbon u::-moz-selection { background-color: #{params[:ribbon_color]}; }

                        .ribbon u:before,
                        .ribbon:after {
                            content: '';
                            position: absolute;
                            height: 8px;
                            left: 0;
                            bottom: 0;
                            -webkit-border-top-left-radius: 50% 8px;
                                    border-top-left-radius: 50% 8px;
                            -webkit-border-top-right-radius: 50% 8px;
                                    border-top-right-radius: 50% 8px;
                            box-shadow: inset 0 2px 3px rgba(0, 0, 0, .3);
                        }
                        .oldie .ribbon u:before,
                        .oldie .ribbon:after {
                            content: none;
                        }

                        .ribbon u:before {
                            width: 100%;
                            background: #{params[:ribbon_color]};
                        }

                        .ribbon:after {
                            width: 100%;
                            background: #{params[:badge_color]};
                            z-index: 1;
                        }
                        .star-text{
                            position: absolute;
                            z-index: 1000;
                            text-align: center;
                            width: 100%;
                            display: block;
                            color: #{params[:bt_color]};
                            font-size: #{params[:badge_size]}px;
                            font-family: #{params[:badge_font]};
                            font-weight: 700;
                            padding: 5px 0;
                            text-shadow: 2px 2px 1px gray;
                        }

                        .arrow-right {
                          background-color: #{params[:corner_color]};
                          height: 400px;
                          left: -200px;
                          position: absolute;
                          bottom: -300px;
                          width: 400px;  
                          -webkit-transform: rotate(-50deg);
                                  transform: rotate(-50deg);
                        }

                         a#btn{
                            padding: 3px 15px;
                            border-radius: 3px;
                            box-shadow: 0 0 3px gray;
                            text-decoration: none;
                            font-size: #{params[:btn_size]}px;
                            background: #{params[:main_color]};
                            color: #{params[:btn_color]};
                            font-family: #{params[:btn_font]};
                            position: absolute;
                            bottom: 5px;
                            right: 100px;
                            transition: 1s all ease;
                         }
                         a#btn:hover{
                            transform: scale(1.2);
                         }

                        .use-code{
                            padding: 20px;
                            border-radius: 3px;
                            margin-right: 10px;
                            box-shadow: 0 0 3px grey;
                            font-size: 13px;
                            margin-top: 20px;
                         }
                        .use-code b{
                            font-size: 30px;
                            margin: 10px 0;
                            display: block;
                         }

                        .pop-product-img{
                            transition: all 2s ease;
                         }

                        .pop-product-img:hover{
                            transform: #{params[:animation]};
                        }


                        .hms-div{
                          margin-left: 20px;
                          text-align: center;
                        }
                        .hms-div p{
                          color: #777;
                          font-size: 10px;
                        }
                        .hms-div div{
                          border-radius: 2px;
                          background: #fff;
                          color: #ff0000;
                          font-family: #{params[:timer_font]};
                          font-size: 25px;
                          width: 40px;
                          box-shadow: 0 0 5px gray;
                          padding: 5px 0 3px;
                          margin: -10px auto;
                        }"
        jsContent    = "$(function() {
                          $('#tsmodal').addClass('animated bounceInDown');
                          $('#close').on('click', function(){
                              $('div#tsmodal-fade').addClass('animated slideOutDown');
                            });
                          var hms = '#{params[:time_left]}';   
                          var a = hms.split(':');
                          var seconds = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]);
                          var selectedSeconds = new Date().getTime() + seconds*1000;    
                          $('div.time-left').countdown(selectedSeconds, {elapse: true})
                          .on('update.countdown', function(event) {
                            var $this = $(this);
                            if (event.elapsed) {
                              $('div#tsmodal-fade').addClass('animated zoomOut');
                            } else {
                              $this.html(event.strftime('<table><tr><td> <div class=\"hms-div\"> <p>HOURS</p> <div>%H</div> </div> </td> <td> <div class=\"hms-div\"> <p>MINUTES</p> <div>%M</div> </div> </td> <td> <div class=\"hms-div\"> <p>SECONDS</p> <div>%S</div>   </div>  </td>   </tr> </table>'));
                            }
                          });
                          $('a#btn').on('click', function(){
                              var redirect_url = $(this).attr('data-link');
                              $.ajax({
                                  url: '#{save_order_url}',
                                  data: { ordername: $(this).attr('data-order'), shop: '#{@shop.shopify_domain}' },
                                  type: 'post',
                                  success: function(response){
                                        if(response.status == 'success'){
                                            window.top.location.href = redirect_url;
                                          }else{
                                            $('div#tsmodal-fade').addClass('animated slideOutDown');
                                          }
                                    }
                                });
                          });

                       });"

        result = "<link href='{{'tspopup.css' | asset_url}}' rel='stylesheet' type='text/css' media='all' />
                  <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
                  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.5.2/animate.min.css'>
                  <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>
                  <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery.countdown/2.2.0/jquery.countdown.min.js'></script>
                  <script src='{{'tspopup.js' | asset_url }}' type='text/javascript' ></script>
                  <div id='tsmodal-fade'>

                  <div id = 'tsmodal' class='preview-dialog' >
                   <div id='close'>X</div>
                   <div class='main-content'>
                    <div class='row'>
                      <div class='col-xs-6'>
                        <h2 class='main-title'>#{params[:main_title]}</h2>               
                        <p class='main-text' >
                          #{params[:main_text]}
                        </p>            
                      </div>
                      <div class='col-xs-6'>
                        <p class='use-code' >
                          YOUR PERSONALIZED DISCOUNT CODE<br>
                          <b class='text-danger'>#{params[:use_code]}</b><br>
                          ENTER CODE AT CHECKOUT
                        </p>          
                      </div>
                    </div>          
                    
                    <div style='position: relative; top: -5%; right: 0;' >
                      <div class='row' >
                        <div class='col-xs-2'></div>
                        <div class='col-xs-4'>
                          <p style='font-size: #{params[:timer_size]}px; color: #{params[:timer_color]}; font-family: #{params[:timer_font]}; margin-right: -40px; margin-top: 15px; '>
                            #{params[:timer_text]}</p>
                        </div>
                        <div class='col-xs-6 time-left' style='font-size: 40px;' >
                          <table>
                            <tr>
                              <td>
                                <div class='hms-div'>
                                  <p>HOURS</p>
                                  <div>00</div>
                                </div>
                              </td>
                              <td>
                                <div class='hms-div'>
                                  <p>MINUTES</p>
                                  <div>20</div>
                                </div>
                              </td>
                              <td>
                                <div class='hms-div'>
                                  <p>SECONDS</p>
                                  <div>00</div>
                                </div>
                              </td>
                            </tr>
                          </table>
                        </div>
                      </div>  
                    </div>

                    <a href='#{params[:btn_link]}' id='btn' data-order='{{order.name}}' >
                      #{params[:btn_txt]}
                    </a>  
                    
                    <div class='arrow-right' ></div>                
                  </div>

                  <div class='round-star-label' >
                    <span class='star-text'>#{params[:percentage]}#{params[:distype]}</span>
                    <h1 class=ribbon>
                      <i><u class='ribbon-text'>#{params[:ribbon_text]}</u></i>
                    </h1>
                  </div>
                </div>

              </div>"

      when 'option3'
        
        styleContent = "@import url('https://fonts.googleapis.com/css?family=Open+Sans');
                        @import url('https://fonts.googleapis.com/css?family=Roboto');
                        @import url('https://fonts.googleapis.com/css?family=Lato');
                        @import url('https://fonts.googleapis.com/css?family=Josefin+Sans');
                        @import url('https://fonts.googleapis.com/css?family=Lobster');
                        @import url('https://fonts.googleapis.com/css?family=Dancing+Script');
                        @import url('https://fonts.googleapis.com/css?family=Playfair+Display');
                        @import url('https://fonts.googleapis.com/css?family=Chewy');
                        @import url('https://fonts.googleapis.com/css?family=Quicksand');
                        @import url('https://fonts.googleapis.com/css?family=Satisfy');
                        @import url('https://fonts.googleapis.com/css?family=Oswald');
                        @import url('https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css');

                        /* Offer setting tab */
                        #tsmodal-fade{position: fixed; top: 0; width: 100%;  height: 100%; z-index: 1000; background: rgba(0,0,0,.5); left: 0;}
                        div#close{ position: absolute; right: calc(50vw - 295px); margin-top: -12px;  background: #{params[:txt_color]};  display: inline-block;  border-radius: 50%;  padding: 2px 7px;  color: #fff;  border: 3px solid #fff;  box-shadow: 0 0 3px grey;  cursor: pointer; transition: all 1s;}
                        div#close:hover{ transform: rotate(360deg)scale(1.3); }

                         div.preview-dialog{
                            text-align: center;
                            margin: auto;
                            margin-top: 10%;
                            border: 5px double #{params[:bd_color]};
                            width: 555px;
                            height: 350px;
                            box-shadow: 0 0 5px grey;
                            background: #{params[:bg_color]};
                         }
                         .main-content{
                            overflow: hidden;
                            width: 100%;
                            height: 100%;
                            position: relative;    
                         }
                         p.main-text{
                            padding: 10px;
                            color: #{params[:txt_color]};
                            font-size: #{params[:font_size]}px;
                            font-family: #{params[:main_font]};
                         }
                        .main-title{
                            color: #{params[:main_t_color]} !important;
                            font-size: #{params[:main_t_size]}px;
                            font-family: #{params[:main_t_font]};
                         }
                        .round-star-label {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: relative;
                          border: none;                          
                          text-align: center;
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          top: -70px;
                          left: 0;

                        }

                        .round-star-label::before {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: absolute;
                          content: '';
                          top: 0;
                          left: 0;
                          border: none;
                          color: rgba(0,0,0,1);
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          text-shadow: none;
                          -webkit-transform: rotateZ(30deg)   ;
                          transform: rotateZ(30deg)   ;
                        }

                        .round-star-label::after {
                          -webkit-box-sizing: content-box;
                          -moz-box-sizing: content-box;
                          box-sizing: content-box;
                          width: 80px;
                          height: 80px;
                          position: absolute;
                          content: '';
                          top: 0;
                          left: 0;
                          border: none;
                          color: rgba(0,0,0,1);
                          -o-text-overflow: clip;
                          text-overflow: clip;
                          background: #{params[:badge_color]};
                          text-shadow: none;
                          -webkit-transform: rotateZ(60deg);
                          transform: rotateZ(60deg);
                        }

                        /* Ribbon */
                        .ribbon {
                            position: relative;
                            width: 80%;
                            margin: 0;
                            z-index: 1000;
                            bottom: -48px;
                            right: -8px;
                        }

                        .ribbon:before,
                        .ribbon i:before {
                            content: '';
                            position: absolute;
                            bottom: -4px;
                            border: 12px solid #{params[:ribbon_color]};
                        }

                        .ribbon:before {
                            left: -26px;
                            border-left-color: transparent;
                            -webkit-transform: rotate(-16deg);
                               -moz-transform: rotate(-16deg);
                                -ms-transform: rotate(-16deg);
                                 -o-transform: rotate(-16deg);
                                    transform: rotate(-16deg);
                        }
                        .oldie .ribbon:before {
                            left: -48px;
                        }

                        .ribbon i:before {
                            right: -26px;
                            border-right-color: transparent;
                            -webkit-transform: rotate(16deg);
                               -moz-transform: rotate(16deg);
                                -ms-transform: rotate(16deg);
                                 -o-transform: rotate(16deg);
                                    transform: rotate(16deg);
                            z-index: -1;
                        }
                        .oldie .ribbon i:before {
                            right: -48px;
                        }

                        .ribbon i:after,
                        .ribbon u:after {
                            content: '';
                            position: absolute;
                            border-style: solid;
                            bottom: -4px;
                            z-index: 0;
                        }

                        .ribbon i:after {
                            right: -16px;
                            border-color: transparent transparent transparent #{params[:ribbon_color]};
                            border-width: 0 0 4px 16px;
                        }

                        .ribbon u:after {
                            left: 0;
                            border-color: transparent #{params[:ribbon_color]} transparent transparent;
                            border-width: 0 16px 4px 0;
                        }

                        .ribbon u {
                            display: block;
                            position: relative;
                            width: 100%;
                            left: -16px;
                            padding: 8px 12px 12px;
                            background: #{params[:ribbon_color]};
                            -webkit-border-top-left-radius: 50% 8px;
                                    border-top-left-radius: 50% 8px;
                            -webkit-border-top-right-radius: 50% 8px;
                                    border-top-right-radius: 50% 8px;
                            text-align: center;
                            text-decoration: none;
                            color: #{params[:rt_color]};
                            text-shadow: 0 1px 1px gray, 0 2px 1px gray;
                            font-size: #{params[:ribbon_size]}px;
                            font-family: #{params[:ribbon_font]};
                            font-style: normal;
                        }
                        .oldie .ribbon u {
                            padding: 0 16px;
                            *left: 0px;
                            *padding: 0;
                        }

                        .ribbon u {
                            left: 0;
                            margin: 0 -16px;
                            width: auto;
                        }

                        .ribbon u::selection { background-color: #{params[:ribbon_color]}; }
                        .ribbon u::-moz-selection { background-color: #{params[:ribbon_color]}; }

                        .ribbon u:before,
                        .ribbon:after {
                            content: '';
                            position: absolute;
                            height: 8px;
                            left: 0;
                            bottom: 0;
                            -webkit-border-top-left-radius: 50% 8px;
                                    border-top-left-radius: 50% 8px;
                            -webkit-border-top-right-radius: 50% 8px;
                                    border-top-right-radius: 50% 8px;
                            box-shadow: inset 0 2px 3px rgba(0, 0, 0, .3);
                        }
                        .oldie .ribbon u:before,
                        .oldie .ribbon:after {
                            content: none;
                        }

                        .ribbon u:before {
                            width: 100%;
                            background: #{params[:ribbon_color]};
                        }

                        .ribbon:after {
                            width: 100%;
                            background: #{params[:badge_color]};
                            z-index: 1;
                        }
                        .star-text{
                            position: absolute;
                            z-index: 1000;
                            text-align: center;
                            width: 100%;
                            display: block;
                            color: #{params[:bt_color]};
                            font-size: #{params[:badge_size]}px;
                            font-family: #{params[:badge_font]};
                            font-weight: 700;
                            padding: 5px 0;
                            text-shadow: 2px 2px 1px gray;
                        }

                        .arrow-right {
                          background-color: #{params[:corner_color]};
                          height: 400px;
                          left: -200px;
                          position: absolute;
                          bottom: -300px;
                          width: 400px;  
                          -webkit-transform: rotate(-50deg);
                                  transform: rotate(-50deg);
                        }

                         a#btn{
                            padding: 3px 15px;
                            border-radius: 3px;
                            box-shadow: 0 0 3px gray;
                            text-decoration: none;
                            font-size: #{params[:btn_size]}px;
                            background: #{params[:main_color]};
                            color: #{params[:btn_color]};
                            font-family: #{params[:btn_font]};
                            position: absolute;
                            bottom: 5px;
                            right: 100px;
                            transition: 1s all ease;
                         }
                         a#btn:hover{
                            transform: scale(1.2);
                         }

                        .use-code{
                            padding: 20px;
                            border-radius: 3px;
                            margin-right: 10px;
                            box-shadow: 0 0 3px #000;
                            font-size: 13px;
                         }
                        .use-code b{
                            font-size: 30px;
                         }

                        .pop-product-img{
                            transition: all 2s ease;
                         }

                        .pop-product-img:hover{
                            transform: #{params[:animation]};
                        }


                        .hms-div{
                          margin-left: 20px;
                          text-align: center;
                        }
                        .hms-div p{
                          color: #777;
                          font-size: 10px;
                        }
                        .hms-div div{
                          border-radius: 2px;
                          background: #fff;
                          color: #ff0000;
                          font-family: #{params[:timer_font]};
                          font-size: 25px;
                          width: 40px;
                          box-shadow: 0 0 5px gray;
                          padding: 5px 0 3px;
                          margin: -10px auto;
                        }"
        jsContent    = "$(function() {
                          $('#tsmodal').addClass('animated bounceInDown');
                          $('#close').on('click', function(){
                              $('div#tsmodal-fade').addClass('animated slideOutDown');
                            });
                          var hms = '#{params[:time_left]}';   
                          var a = hms.split(':');
                          var seconds = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]);
                          var selectedSeconds = new Date().getTime() + seconds*1000;    
                          $('div.time-left').countdown(selectedSeconds, {elapse: true})
                          .on('update.countdown', function(event) {
                            var $this = $(this);
                            if (event.elapsed) {
                              $('div#tsmodal-fade').addClass('animated zoomOut');
                            } else {
                              $this.html(event.strftime('<table><tr><td> <div class=\"hms-div\"> <p>HOURS</p> <div>%H</div> </div> </td> <td> <div class=\"hms-div\"> <p>MINUTES</p> <div>%M</div> </div> </td> <td> <div class=\"hms-div\"> <p>SECONDS</p> <div>%S</div>   </div>  </td>   </tr> </table>'));
                            }
                          });
                          $('a#btn').on('click', function(){
                              var redirect_url = $(this).attr('data-link');
                              $.ajax({
                                  url: '#{save_order_url}',
                                  data: { ordername: $(this).attr('data-order'), shop: '#{@shop.shopify_domain}' },
                                  type: 'post',
                                  success: function(response){
                                        if(response.status == 'success'){
                                            window.top.location.href = redirect_url;
                                          }else{
                                            $('div#tsmodal-fade').addClass('animated slideOutDown');
                                          }
                                    }
                                });
                          });

                       });"

        

        result = "<link href='{{'tspopup.css' | asset_url}}' rel='stylesheet' type='text/css' media='all' />
                  <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
                  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.5.2/animate.min.css'>
                  <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>
                  <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery.countdown/2.2.0/jquery.countdown.min.js'></script>
                  <script src='{{'tspopup.js' | asset_url }}' type='text/javascript' ></script>
                  <div id='tsmodal-fade'>

                  <div id = 'tsmodal' class='preview-dialog' >
                   <div id='close'>X</div>
                   <div class='main-content'>
                    <br>
                    <div class='row'>                 
                      <div class='col-xs-4'>
                        <a href='https://#{ShopifyAPI::Shop.current.domain}/products/#{params[:product].split(':::')[1]}'>
                          <img src='#{params[:product].split(':::')[0]}' width='90%' class='pop-product-img' >
                        </a>          
                      </div>
                      <div class='col-xs-4'>
                        <a href='https://#{ShopifyAPI::Shop.current.domain}/products/#{params[:product1].split(':::')[1]}'>
                          <img src='#{params[:product1].split(':::')[0]}' width='90%' class='pop-product-img' >
                        </a>          
                      </div>
                      <div class='col-xs-4'>
                        <a href='https://#{ShopifyAPI::Shop.current.domain}/products/#{params[:product2].split(':::')[1]}'>
                          <img src='#{params[:product2].split(':::')[0]}' width='90%' class='pop-product-img' >
                        </a>          
                      </div>                  
                    </div>          
                    
                    <div style='position: relative; top: -15%; right: 0;' >
                      <div class='row'>
                        <div class='col-xs-12'>
                          <h1 class='main-title'>Best Seller Collection</h1>
                        </div>
                      </div>
                      <div class='row' >
                        <div class='col-xs-2'></div>
                        <div class='col-xs-4'>
                          <p style='font-size: #{params[:timer_size]}px; color: #{params[:timer_color]}; font-family: #{params[:timer_font]}; margin-right: -40px; margin-top: 15px; '>
                            #{params[:timer_text]}</p>
                        </div>
                        <div class='col-xs-6 time-left' style='font-size: 40px;' >
                          <table>
                            <tr>
                              <td>
                                <div class='hms-div'>
                                  <p>HOURS</p>
                                  <div>00</div>
                                </div>
                              </td>
                              <td>
                                <div class='hms-div'>
                                  <p>MINUTES</p>
                                  <div>20</div>
                                </div>
                              </td>
                              <td>
                                <div class='hms-div'>
                                  <p>SECONDS</p>
                                  <div>00</div>
                                </div>
                              </td>
                            </tr>
                          </table>
                        </div>
                      </div>  
                    </div>

                    <a href='#{params[:btn_link]}' id='btn' data-order='{{order.name}}' >
                      #{params[:btn_txt]}
                    </a>  
                    
                    <div class='arrow-right' ></div>                
                  </div>

                  <div class='round-star-label' >
                    <span class='star-text'>#{params[:percentage]}#{params[:distype]}</span>
                    <h1 class=ribbon>
                      <i><u class='ribbon-text'>#{params[:ribbon_text]}</u></i>
                    </h1>
                  </div>
                </div>

              </div>"

    end    
    

    begin

      style       = ShopifyAPI::Asset.find( 'assets/tspopup.css', :theme_id => theme.id )
      style.value = styleContent

      js          = ShopifyAPI::Asset.find( 'assets/tspopup.js', :theme_id => theme.id )
      js.value    = jsContent

    rescue
      
      style       = ShopifyAPI::Asset.new(:theme_id => theme.id, :key => "assets/tspopup.css", :value => styleContent )
      js          = ShopifyAPI::Asset.new(:theme_id => theme.id, :key => "assets/tspopup.js", :value => jsContent )

    end
    
    # render json: { result: theme.id }
    
    if style.save and js.save
      if @shop.modaloptions.first.nil?
        @option = @shop.modaloptions.build(option_params)
        @option.save
      else
        @option.update(option_params)
      end      
      render json: { status: 'success', result: result }
    else
      render json: { status: 'failure' }
    end

  end  

  private
  def set_option
      @shop = Shop.where(:shopify_domain => ShopifyAPI::Shop.current.domain).first

      if @shop.modaloptions.first.nil?
        @option = nil
      else
        @option = @shop.modaloptions.first
      end
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def option_params
      params.permit( 
        :option,
        :main_text,
        :txt_color,
        :time_left,
        :main_font,
        :font_size,
        :timer_color,
        :timer_font,      
        :timer_text,
        :timer_size,
        :btn_link,
        :btn_color,     
        :main_color,
        :btn_txt,
        :btn_font,
        :btn_size,
        :bg_color,
        :bd_color,
        :percentage,
        :distype,
        :use_code,
        :product,
        :product1,
        :product2,
        :animation,
        :main_title,
        :main_t_color,
        :main_t_size,
        :main_t_font,
        :ribbon_text,
        :ribbon_color,
        :rt_color,
        :ribbon_font,
        :ribbon_size,
        :badge_size,
        :badge_font,
        :badge_color,
        :bt_color,
        :corner_color,
        :pb_txt,
        :pb_color,
        :pb_bg_color,
        :pb_font,
        :pb_mb_pos,
        :pb_desk_pos
      )
  end  

end