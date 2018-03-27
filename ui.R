shinyUI(
  dashboardPage(skin = "blue",
    dashboardHeader(title = "IN Patent Dashboard"
    ),
    dashboardSidebar(
      sidebarMenu(id="tabs",
        menuItem("Table View", tabName = "table_view", icon = icon("table")),
        menuItem("Network Vis", tabName = "network_vis", icon = icon("sitemap")),
        menuItem("Pull New Data", tabName = "pull_data", icon = icon("database"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "table_view",
          fluidRow(
            column(12,
              selectInput("selected_field_list", label = "Select From Available Fields:",
                choices = colnames(IN_patent_data_combined),
                multiple = TRUE,
                selected = c("patent_id","patent_title","patent_date","inventor_first_name", "inventor_last_name","assignee_organization"),
                width = "100%"
              )
            )
          ),
          dataTableOutput("table_of_all_data"),
          br(),
          div(style="float:right", downloadButton("download_all_data", "Download Data")),
          br()
        ),
        tabItem(tabName = "network_vis",
          fluidRow(
            column(3,
              selectInput("network_top_num", label = "Top ? Cited Patents",
                choices = c(10,25,50,100),
                multiple = FALSE,
                selected = c(10),
                width = "100%"
              )
            ),
            column(3,
              selectInput("network_include", label = "Include",
                choices = c("Assignees","Inventors", "Assignees and Inventors"),
                multiple = FALSE,
                selected = c("Assignees and Inventors"),
                width = "100%"
              )
            ),
            column(3,
              radioButtons("network_plot_or_data", "Plot or Data",
                c("Plot" = "network_pickedPlot", "Data" = "network_pickedData" ),
                selected = "network_pickedPlot",
                inline = T
              )
            )
          ),
          br(),
          conditionalPanel(
            condition = "input.network_plot_or_data=='network_pickedPlot'",
            visNetworkOutput("network_vis_plot", width = "100%", height = "750px")
          ),
          conditionalPanel(
            condition = "input.network_plot_or_data=='network_pickedData'",
            dataTableOutput("network_data"),
            br(),
            div(style="float:right", downloadButton("download_network_data", "Download Data")),
            br()
          )
        ),
        tabItem(tabName = "pull_data",
          fluidRow(
            column(12,
              helpText("Click below to pull new data (this can take a while). A notification will display when it is done."),
              actionButton("pull_new_data", "Update Data"),
              br(),
              br(),
              textOutput("upload_status"),
              br(),
              helpText("Last time data was updated:"),
              textOutput("upload_date"),
              br(),
              br(),
              br()
            )
          )
        )  
      )
    )
  )
)