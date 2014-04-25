class ComputersController < ApplicationController
  before_action :set_computer, only: [:show, :edit, :update, :destroy, :power_on, :power_off, :update_power_status]

  # GET /computers
  # GET /computers.json
  def index
    @computers = Computer.all
    
    #
    #@computers.each do |computer|
    #  computer.update_power_status
    #end
    
  end
  
  def update_all_power_status
    @computers = Computer.all
        
    @computers.each do |computer|
      computer.update_power_status
    end
    
    respond_to do |format|      
        format.html { redirect_to computers_path, notice: 'Computers power status refreshed.' }
        format.json { head :no_content }      
    end
  end

  # GET /computers/1
  # GET /computers/1.json
  def show
  end

  # GET /computers/new
  def new
    @computer = Computer.new
  end

  # GET /computers/1/edit
  def edit
  end

  # POST /computers
  # POST /computers.json
  def create
    @computer = Computer.new(computer_params)

    respond_to do |format|
      if @computer.save
        format.html { redirect_to @computer, notice: 'Computer was successfully created.' }
        format.json { render :show, status: :created, location: @computer }
      else
        format.html { render :new }
        format.json { render json: @computer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /computers/1
  # PATCH/PUT /computers/1.json
  def update
    respond_to do |format|
      if @computer.update(computer_params)
        format.html { redirect_to @computer, notice: 'Computer was successfully updated.' }
        format.json { render :show, status: :ok, location: @computer }
      else
        format.html { render :edit }
        format.json { render json: @computer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /computers/1
  # DELETE /computers/1.json
  def destroy
    @computer.destroy
    respond_to do |format|
      format.html { redirect_to computers_url }
      format.json { head :no_content }
    end
  end
  
  def power_on
    @computer.power_on
    respond_to do |format|      
        format.html { redirect_to computers_url, notice: "Wake on LAN operation in progress for #{@computer.name}" }
        format.json { render :show, status: :ok, location: @computer }      
    end
  end
  
  def power_off
    @computer.power_off
    respond_to do |format|      
        format.html { redirect_to computers_url, notice: "Shutdown operation in progress for #{@computer.name}" }
        format.json { render :show, status: :ok, location: @computer }      
    end
  end
  
  def update_power_status                
    @computer.update_power_status    
    
    respond_to do |format|      
        format.html { redirect_to @computer, notice: "#{@computer.name} power status refreshed." }
        format.json { render :show, status: :ok, location: @computer }  
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_computer
      @computer = Computer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def computer_params
      params.require(:computer).permit(:ip_address, :mac_address, :name, :username, :password, :netmask_cidr)
    end
end
